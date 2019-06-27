eGobiError telit_srv_fun_unpack(uint8_t *rsp, uint16_t len, srv_fun_out_t *out)
{
    ULONG ret = eGOBI_ERR_INVALID_ARG;
    uint16_t qmi_error = 0;
    uint16_t payload;
    uint8_t *msg;
    srv_fun_ response;

    if (!out || !rsp)
        goto end;

    payload = get_payload_size(rsp);
    msg = rsp + sizeof(sQMIServiceRawTransactionHeader) + \
        sizeof(sQMIRawMessageHeader);

    ret = validate_message(msg, payload, &qmi_error);
    if (ret == eGOBI_ERR_MALFORMED_RSP) {
        ret = (eGobiError)(qmi_error + eGOBI_ERR_QMI_OFFSET);
        goto end;
    }

    if (ret != eGOBI_ERR_NONE)
        goto end;

    memset(&response, 0, sizeof(response));
    ret = srv_fun_unpack(payload, msg, &response);
    if (ret != eGOBI_ERR_NONE)
        goto end;

end:
    return (eGobiError)ret;
}
