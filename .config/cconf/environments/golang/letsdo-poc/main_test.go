package main

import (
	"io/ioutil"
	"os"
	"path/filepath"
	"strings"
	"testing"
	"time"

	"github.com/spf13/cobra"
	"github.com/stretchr/testify/assert"
)

func createTempDataDir(t *testing.T) (string, error) {
	tempDir, err := ioutil.TempDir("", "letsdo_test_")
	if err != nil {
		return "", err
	}
	dataDir := filepath.Join(tempDir, ".letsdo")
	if err := os.MkdirAll(dataDir, 0700); err != nil {
		os.RemoveAll(tempDir)
		return "", err
	}
	return tempDir, nil
}

func createTestDataStore(t *testing.T, tempDir string) (DataStore, error) {
	filePath := filepath.Join(tempDir, ".letsdo", "tasks.yaml")
	return &letsdo.DataStore{filePath: filePath}, nil
}

func loadTasksFromTestStore(t *testing.T, store DataStore) []Task {
	tasks, err := store.LoadTasks()
	assert.NoError(t, err)
	return tasks
}

func TestTaskManager_CreateTask(t *testing.T) {
	tempDir, err := createTempDataDir(t)
	if err != nil {
		t.Fatalf("failed to create temp data dir: %v", err)
	}
	defer os.RemoveAll(tempDir)

	store, err := createTestDataStore(t, tempDir)
	assert.NoError(t, err)

	taskManager := letsdo.NewTaskManager(store)

	description1 := "Test task 1 #tag1 +projA @ctxX"
	err = taskManager.CreateTask(description1)
	assert.NoError(t, err)

	tasks := loadTasksFromTestStore(t, store)
	assert.Len(t, tasks, 1)
	assert.Equal(t, "Test task 1", tasks[0].Description)
	assert.Equal(t, "tag1", tasks[0].Tag)
	assert.Equal(t, "projA", tasks[0].Project)
	assert.Equal(t, "ctxX", tasks[0].Context)
	assert.False(t, tasks[0].Start.IsZero())
	assert.True(t, tasks[0].Stop.IsZero())
	assert.Equal(t, taskManager.GenerateIDFromDescription(description1), tasks[0].ID)

	description2 := "Test task 1 #tag1 +projA @ctxX" // Same description
	err = taskManager.CreateTask(description2)
	assert.NoError(t, err) // Should not create a new task, just inform

	tasks = loadTasksFromTestStore(t, store)
	assert.Len(t, tasks, 1) // Still only one task

	description3 := "Another task"
	err = taskManager.CreateTask(description3)
	assert.NoError(t, err)

	tasks = loadTasksFromTestStore(t, store)
	assert.Len(t, tasks, 2)
	assert.Equal(t, "Another task", tasks[1].Description)
	assert.Equal(t, "", tasks[1].Tag)
	assert.Equal(t, "", tasks[1].Project)
	assert.Equal(t, "", tasks[1].Context)
	assert.False(t, tasks[1].Start.IsZero())
	assert.True(t, tasks[1].Stop.IsZero())
	assert.Equal(t, taskManager.GenerateIDFromDescription(description3), tasks[1].ID)
}

func TestTaskManager_IsTaskRunning(t *testing.T) {
	tempDir, err := createTempDataDir(t)
	if err != nil {
		t.Fatalf("failed to create temp data dir: %v", err)
	}
	defer os.RemoveAll(tempDir)

	store, err := createTestDataStore(t, tempDir)
	assert.NoError(t, err)

	taskManager := letsdo.NewTaskManager(store)

	// No tasks
	isRunning, err := taskManager.IsTaskRunning()
	assert.NoError(t, err)
	assert.False(t, isRunning)

	// One running task
	err = taskManager.CreateTask("Running task")
	assert.NoError(t, err)
	isRunning, err = taskManager.IsTaskRunning()
	assert.NoError(t, err)
	assert.True(t, isRunning)

	// Stop the task
	err = taskManager.StopTask("Running task")
	assert.NoError(t, err)
	isRunning, err = taskManager.IsTaskRunning()
	assert.NoError(t, err)
	assert.False(t, isRunning)

	// Another running task
	err = taskManager.CreateTask("Another running task")
	assert.NoError(t, err)
	isRunning, err = taskManager.IsTaskRunning()
	assert.NoError(t, err)
	assert.True(t, isRunning)
}

func TestTaskManager_StopTask(t *testing.T) {
	tempDir, err := createTempDataDir(t)
	if err != nil {
		t.Fatalf("failed to create temp data dir: %v", err)
	}
	defer os.RemoveAll(tempDir)

	store, err := createTestDataStore(t, tempDir)
	assert.NoError(t, err)

	taskManager := letsdo.NewTaskManager(store)

	err = taskManager.CreateTask("Task to stop")
	assert.NoError(t, err)

	tasks := loadTasksFromTestStore(t, store)
	assert.Len(t, tasks, 1)
	assert.True(t, tasks[0].Stop.IsZero())

	time.Sleep(10 * time.Millisecond) // Ensure stop time is different

	err = taskManager.StopTask("Task to stop")
	assert.NoError(t, err)

	tasks = loadTasksFromTestStore(t, store)
	assert.Len(t, tasks, 1)
	assert.False(t, tasks[0].Stop.IsZero())
	assert.NotEqual(t, tasks[0].Start, tasks[0].Stop)

	err = taskManager.StopTask("Non-existent task")
	assert.Error(t, err)
	assert.Contains(t, err.Error(), "no running task found")
}

func TestTaskManager_ListTasks(t *testing.T) {
	tempDir, err := createTempDataDir(t)
	if err != nil {
		t.Fatalf("failed to create temp data dir: %v", err)
	}
	defer os.RemoveAll(tempDir)

	store, err := createTestDataStore(t, tempDir)
	assert.NoError(t, err)

	taskManager := letsdo.NewTaskManager(store)

	// No tasks
	oldStdout := os.Stdout
	r, w, _ := os.Pipe()
	os.Stdout = w

	err = taskManager.ListTasks()
	assert.NoError(t, err)

	w.Close()
	outBytes, _ := ioutil.ReadAll(r)
	output := string(outBytes)
	os.Stdout = oldStdout

	assert.Contains(t, output, "No tasks yet!")

	// Add some tasks
	err = taskManager.CreateTask("Task A #tagA")
	assert.NoError(t, err)
	err = taskManager.CreateTask("Task B +projB @ctxC")
	assert.NoError(t, err)
	err = taskManager.StopTask("Task A")
	assert.NoError(t, err)

	oldStdout = os.Stdout
	r, w, _ = os.Pipe()
	os.Stdout = w

	err = taskManager.ListTasks()
	assert.NoError(t, err)

	w.Close()
	outBytes, _ = ioutil.ReadAll(r)
	output = string(outBytes)
	os.Stdout = oldStdout

	assert.Contains(t, output, "Tasks:")
	assert.Contains(t, output, "ID: "+taskManager.GenerateIDFromDescription("Task A #tagA"))
	assert.Contains(t, output, "Description: Task A")
	assert.Contains(t, output, "Tag: tagA")
	assert.Contains(t, output, "Stop:")
	assert.Contains(t, output, "ID: "+taskManager.GenerateIDFromDescription("Task B +projB @ctxC"))
	assert.Contains(t, output, "Description: Task B")
	assert.Contains(t, output, "Project: projB")
	assert.Contains(t, output, "Context: ctxC")
	assert.NotContains(t, output, "Stop:", "Task B should not be stopped")
}

func TestCommandLineInterface(t *testing.T) {
	tempDir, err := createTempDataDir(t)
	if err != nil {
		t.Fatalf("failed to create temp data dir: %v", err)
	}
	defer os.RemoveAll(tempDir)

	dataFilePath := filepath.Join(tempDir, ".letsdo", "tasks.yaml")

	executeCommand := func(args ...string) (string, error) {
		rootCmd := &cobra.Command{Use: "letsdo"}
		store, err := letsdo.NewDataStore()
		if err != nil {
			return "", err
		}
		store.filePath = dataFilePath // Override the default path for testing
		taskManager := letsdo.NewTaskManager(store)

		var doCmd = &cobra.Command{
			Use:   "do <description>",
			Short: "Start a new task",
			Args:  cobra.MinimumNArgs(1),
			RunE: func(cmd *cobra.Command, args []string) error {
				description := strings.Join(args, " ")
				return taskManager.CreateTask(description)
			},
		}

		var stopCmd = &cobra.Command{
			Use:   "stop <description>",
			Short: "Stop a running task",
			Args:  cobra.MinimumNArgs(1),
			RunE: func(cmd *cobra.Command, args []string) error {
				description := strings.Join(args, " ")
				return taskManager.StopTask(description)
			},
		}

		var listCmd = &cobra.Command{
			Use:   "list",
			Short: "List all tasks",
			RunE: func(cmd *cobra.Command, args []string) error {
				oldStdout := os.Stdout
				r, w, _ := os.Pipe()
				os.Stdout = w

				err := taskManager.ListTasks()

				w.Close()
				outBytes, _ := ioutil.ReadAll(r)
				output := string(outBytes)
				os.Stdout = oldStdout
				cmd.Println(output)
				return err
			},
		}

		rootCmd.AddCommand(doCmd, stopCmd, listCmd)

		oldArgs := os.Args
		defer func() { os.Args = oldArgs }()
		os.Args = append([]string{"letsdo"}, args...)

		oldStdout := os.Stdout
		r, w, _ := os.Pipe()
		os.Stdout = w

		err := rootCmd.Execute()

		w.Close()
		outBytes, _ := ioutil.ReadAll(r)
		output := string(outBytes)
		os.Stdout = oldStdout

		return output, err
	}

	// Test 'do' command
	output, err := executeCommand("do", "CLI test task")
	assert.NoError(t, err)
	assert.Contains(t, output, "Started task: CLI test task")

	// Test 'list' command
	output, err = executeCommand("list")
	assert.NoError(t, err)
	assert.Contains(t, output, "CLI test task")

	// Test 'stop' command
	output, err = executeCommand("stop", "CLI test task")
	assert.NoError(t, err)
	assert.Contains(t, output, "Stopped task: CLI test task")

	// Test 'list' after stopping
	output, err = executeCommand("list")
	assert.NoError(t, err)
	assert.Contains(t, output, "CLI test task")
	assert.Contains(t, output, "Stop:")
}
