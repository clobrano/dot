package main

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/spf13/cobra"
	"gopkg.in/yaml.v3"
)

const appName = "letsdo"
const dataDirName = ".letsdo"
const dataFileName = "tasks.yaml"

// Task represents a task with its attributes.
type Task struct {
	ID          string    `yaml:"id"`
	Description string    `yaml:"description"`
	Tag         string    `yaml:"tag,omitempty"`
	Project     string    `yaml:"project,omitempty"`
	Context     string    `yaml:"context,omitempty"`
	Start       time.Time `yaml:"start"`
	Stop        time.Time `yaml:"stop,omitempty"`
}

// DataStore manages the storage of tasks.
type DataStore struct {
	filePath string
}

// NewDataStore creates a new DataStore instance.
func NewDataStore() (*DataStore, error) {
	home, err := os.UserHomeDir()
	if err != nil {
		return nil, fmt.Errorf("could not get user home directory: %w", err)
	}
	dataDir := filepath.Join(home, dataDirName)
	if _, err := os.Stat(dataDir); os.IsNotExist(err) {
		if err := os.MkdirAll(dataDir, 0700); err != nil {
			return nil, fmt.Errorf("could not create data directory: %w", err)
		}
	}
	filePath := filepath.Join(dataDir, dataFileName)
	return &DataStore{filePath: filePath}, nil
}

// LoadTasks loads tasks from the YAML file.
func (ds *DataStore) LoadTasks() ([]Task, error) {
	data, err := os.ReadFile(ds.filePath)
	if err != nil {
		if os.IsNotExist(err) {
			return []Task{}, nil
		}
		return nil, fmt.Errorf("could not read task file: %w", err)
	}
	var tasks []Task
	if err := yaml.Unmarshal(data, &tasks); err != nil {
		return nil, fmt.Errorf("could not unmarshal task data: %w", err)
	}
	return tasks, nil
}

// SaveTasks saves tasks to the YAML file.
func (ds *DataStore) SaveTasks(tasks []Task) error {
	data, err := yaml.Marshal(&tasks)
	if err != nil {
		return fmt.Errorf("could not marshal tasks: %w", err)
	}
	if err := os.WriteFile(ds.filePath, data, 0600); err != nil {
		return fmt.Errorf("could not write task file: %w", err)
	}
	return nil
}

// TaskManager handles the business logic for tasks.
type TaskManager struct {
	store *DataStore
}

// NewTaskManager creates a new TaskManager instance.
func NewTaskManager(store *DataStore) *TaskManager {
	return &TaskManager{store: store}
}

// IsTaskRunning checks if another task is currently running (has a non-zero Start time and a zero Stop time).
func (tm *TaskManager) IsTaskRunning() (bool, error) {
	tasks, err := tm.store.LoadTasks()
	if err != nil {
		return false, err
	}
	for _, task := range tasks {
		if !task.Start.IsZero() && task.Stop.IsZero() {
			return true, nil
		}
	}
	return false, nil
}

// GenerateIDFromDescription generates a SHA-256 hash of the description.
func (tm *TaskManager) GenerateIDFromDescription(description string) string {
	hasher := sha256.New()
	hasher.Write([]byte(description))
	return hex.EncodeToString(hasher.Sum(nil))
}

// FindTaskByID searches for a task with the given ID.
func (tm *TaskManager) FindTaskByID(id string) (bool, error) {
	tasks, err := tm.store.LoadTasks()
	if err != nil {
		return false, err
	}
	for _, task := range tasks {
		if task.ID == id {
			return true, nil
		}
	}
	return false, nil
}

// CreateTask creates a new task.
func (tm *TaskManager) CreateTask(description string) error {
	isRunning, err := tm.IsTaskRunning()
	if err != nil {
		return err
	}
	if isRunning {
		return fmt.Errorf("another task is currently running")
	}

	id := tm.GenerateIDFromDescription(description)
	tag := ""
	project := ""
	context := ""

	parts := strings.Fields(description)
	for _, part := range parts {
		if strings.HasPrefix(part, "#") {
			tag = strings.TrimPrefix(part, "#")
		} else if strings.HasPrefix(part, "+") {
			project = strings.TrimPrefix(part, "+")
		} else if strings.HasPrefix(part, "@") {
			context = strings.TrimPrefix(part, "@")
		}
	}

	newTask := Task{
		ID:          id,
		Description: description,
		Tag:         tag,
		Project:     project,
		Context:     context,
		Start:       time.Now(),
	}

	tasks, err := tm.store.LoadTasks()
	if err != nil {
		return err
	}
	tasks = append(tasks, newTask)
	return tm.store.SaveTasks(tasks)
}

// stopTask stops a running task based on its description.
func (tm *TaskManager) StopTask() (error, *Task) {
	tasks, err := tm.store.LoadTasks()
	if err != nil {
		return err, nil
	}
	if len(tasks) == 0 {
		fmt.Println("No tasks yet!")
		return nil, nil
	}
	found := false
	var task Task
	var i int
	for i, task = range tasks {
		if !task.Start.IsZero() && task.Stop.IsZero() {
			tasks[i].Stop = time.Now()
			found = true
			break
		}
	}

	if !found {
		return fmt.Errorf("no running task found"), nil
	}

	return tm.store.SaveTasks(tasks), &task
}

// listTasks lists all tasks.
func (tm *TaskManager) ListTasks() error {
	tasks, err := tm.store.LoadTasks()
	if err != nil {
		return err
	}
	if len(tasks) == 0 {
		fmt.Println("No tasks yet!")
		return nil
	}
	fmt.Println("Tasks:")
	for _, task := range tasks {
		stopStr := ""
		if !task.Stop.IsZero() {
			stopStr = task.Stop.Format(time.RFC3339)
		}
		fmt.Printf("  ID: %s\n", task.ID)
		fmt.Printf("  Description: %s\n", task.Description)
		if task.Tag != "" {
			fmt.Printf("  Tag: %s\n", task.Tag)
		}
		if task.Project != "" {
			fmt.Printf("  Project: %s\n", task.Project)
		}
		if task.Context != "" {
			fmt.Printf("  Context: %s\n", task.Context)
		}
		fmt.Printf("  Start: %s\n", task.Start.Format(time.RFC3339))
		if stopStr != "" {
			fmt.Printf("  Stop: %s\n", stopStr)
		}
		fmt.Println("---")
	}
	return nil
}

func main() {
	store, err := NewDataStore()
	if err != nil {
		fmt.Fprintln(os.Stderr, "Error initializing data store:", err)
		os.Exit(1)
	}
	taskManager := NewTaskManager(store)

	var rootCmd = &cobra.Command{
		Use:   appName,
		Short: "A simple task tracking CLI",
	}

	var doCmd = &cobra.Command{
		Use:   "do <description>",
		Short: "Start a new task",
		Args:  cobra.MinimumNArgs(1),
		Run: func(cmd *cobra.Command, args []string) {

			var err error
			DataStore, err = datastore.NewDataStore()
			if err != nil {
				fmt.Fprintln(os.Stderr, "Error initializing data store:", err)
				os.Exit(1)
			}
			TaskManager = taskmanager.NewTaskManager(DataStore)

			description := strings.Join(args, " ")
			err := taskManager.CreateTask(description)
			if err != nil {
				fmt.Fprintln(os.Stderr, "Error starting task:", err)
				os.Exit(1)
			}
			fmt.Printf("Started task: %s (ID: %s)\n", description, taskManager.GenerateIDFromDescription(description))
		},
	}

	var stopCmd = &cobra.Command{
		Use:   "stop <description>",
		Short: "Stop a running task",
		Run: func(cmd *cobra.Command, args []string) {
			err, task := taskManager.StopTask()
			if err != nil {
				fmt.Fprintln(os.Stderr, "Error stopping task:", err)
				os.Exit(1)
			}
			fmt.Printf("Stopped task: %s\n", task.Description)
		},
	}

	var listCmd = &cobra.Command{
		Use:   "list",
		Short: "List all tasks",
		Run: func(cmd *cobra.Command, args []string) {
			err := taskManager.ListTasks()
			if err != nil {
				fmt.Fprintln(os.Stderr, "Error listing tasks:", err)
				os.Exit(1)
			}
		},
	}

	rootCmd.AddCommand(doCmd)
	rootCmd.AddCommand(stopCmd)
	rootCmd.AddCommand(listCmd)

	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}
