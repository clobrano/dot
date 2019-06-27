eGobiError telit_srv_fun_pack(pack_qmi_t *req_ctx, uint8_t *req, uint16_t *len, srv_fun_t *input)
{
    ULONG li = 0;
    uint8_t *tmpBuf;

    if (!req_ctx || !req)
        return eGOBI_ERR_INVALID_ARG;

    req_ctx->msgid = eQMI_;
    req_ctx->svc = eQMI_SVC_;
    req_ctx->timeout = QMI_TIMEOUT_SMALL;

    input_t input = (input_t)(*req);

    li = srv_fun_pack(input, (uint8_t *)req);

    tmpBuf = (uint8_t *)malloc(li);
    memcpy(tmpBuf, req, li);
    *len = add_header(req_ctx, tmpBuf, li, (uint8_t *)req);
    free(tmpBuf);

    return eGOBI_ERR_NONE;
}
