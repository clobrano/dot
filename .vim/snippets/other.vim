iabbr spackreq <esc>:-1r! sed -n 3,16p ~/config/nvim/snippets/other.vim
" ---
"    /* pack mandatory TLV $tlv_id */
"    tlv_sz = sizeof(QMI_$SRV_$FUNC_request_$tlv_id_t);

"    CHECK_PACK_TLV_SIZE(tlv_sz, hdr_sz, payload_len, *len);

"    hdr = (QMI_raw_content_header_t *)(buf_position);
"    hdr->type_id = $tlv_id;
"    hdr->length = htole16(tlv_sz);
"    buf_position += hdr_sz;

"    tlv_$tlv_id = (QMI_$SRV_$FUNC_request_$tlv_id_t *)buf_position;
"    COPY_HTOM(tlv_$tlv_id->$value, input->$value);

"    buf_position += tlv_sz;
" ---
iabbr spackopt <esc>:-1r! sed -n 20,36p ~/config/nvim/snippets/other.vim
" ---
"    /* pack optional TLV $tlv_id */
"    if (input->$value_available) {
"        QMI_$SRV_$FUNC_request_$tlv_id_t *tlv_$tlv_id;
"        tlv_sz = sizeof(QMI_$SRV_$FUNC_request_$tlv_id_t);
"
"        CHECK_PACK_TLV_SIZE(tlv_sz, hdr_sz, payload_len, *len);
"
"        hdr = (QMI_raw_content_header_t *)(buf_position);
"        hdr->type_id = $tlv_id;
"        hdr->length = htole16(tlv_sz);
"        buf_position += hdr_sz;
"
"        tlv_$tlv_id = (QMI_$SRV_$FUNC_request_$tlv_id_t *)buf_position;
"        COPY_HTOM(tlv_$tlv_id->$value, input->$value);
"
"        buf_position += tlv_sz;
"    }
" ---
iabbr sunpackreq <esc>:-1r! sed -n 40,47p ~/config/nvim/snippets/other.vim
" ---
"    // Unpack mandatory TLV $tlv_id
"    FIND_MANDATORY_TLV(msg, $tlv_id, payload_len, hdr);
"    CHECK_UNPACK_TLV_SIZE(QMI_$SRV_$FUNC_response_$tlv_id_t);
"
"    hdr++;
"    tlv_$tlv_id = (QMI_$SRV_$FUNC_response_$tlv_id_t *)hdr;
"
"    COPY_MTOH(out->$value, tlv_$tlv_id->$value);
" ---
iabbr sunpackopt <esc>:-1r! sed -n 51,62p ~/config/nvim/snippets/other.vim
" ---
"    // Unpack optional TLV $tlv_id
"    hdr = search_TLV(msg, $tlv_id, payload_len);
"    if (hdr) {
"        QMI_$SRV_$FUNC_response_$tlv_id_t *tlv_$tlv_id;
"
"        CHECK_UNPACK_TLV_SIZE(QMI_$SRV_$FUNC_response_$tlv_id_t);
"
"        hdr++;
"        tlv_$tlv_id = (QMI_$SRV_$FUNC_response_$tlv_id_t *)hdr;
"        COPY_MTOH(out->$value, tlv_$tlv_id->$value);
"        out->$value_available = true;
"    }
" ---
iabbr sunpackstub <esc>:-1r! sed -n 66,85p ~/config/nvim/snippets/other.vim
" ---
"tGobiError telit_$srv_$func_unpack(uint8_t *rsp, uint16_t len, $srv_$func_resp_t *out)
"{
"    tGobiError ret;
"    QMI_raw_content_header_t *hdr = NULL;
"    uint16_t payload_len = 0;
"    uint8_t *msg;
"
"    ret = validate_unpack(rsp, len, (void *)out, true, &payload_len, &msg);
"    if (ret != tGOBI_ERR_NONE) {
"        RLOGE("%s: validate unpack failed", __FUNCTION__);
"        goto end;
"    }
"
"    memset(out, 0, sizeof(*out));
"
"   /* code here */
"
"end:
"    return ret;
"}
"" ---
iabbr spackstub <esc>:-1r! sed -n 89,117p ~/config/nvim/snippets/other.vim
" ---
"tGobiError telit_$srv_$func_pack(pack_qmi_t *req_ctx, void *req, uint16_t *len, $srv_$func_t *input)
"{
"    tGobiError ret = tGOBI_ERR_INVALID_ARG;
"    QMI_raw_content_header_t *hdr;
"    uint16_t payload_len = 0;
"    uint8_t *buf_position;
"    uint8_t *original_buf;
"    uint32_t hdr_sz;
"    uint16_t tlv_sz;
"
"    if (!req_ctx || !req || !input || !len)
"        goto end;

"    req_ctx->msgid   = tQMI_$SRV_$FUNC;
"    req_ctx->svc     = tQMI_SVC_$SRV;
"    req_ctx->timeout = QMI_TIMEOUT_SMALL;
"
"    original_buf = (uint8_t *)req;
"    buf_position = skip_msg_header(req);
"
"    hdr_sz = sizeof(QMI_raw_content_header_t);
"
"    /* code here */
"
"    add_header(req_ctx, NULL, payload_len, original_buf, len);
"
"end:
"    return ret;
"}
" ---
iabbr sgetstring <esc>:-1r! sed -n 121,126p ~/config/nvim/snippets/other.vim
" ---
"    ret = get_string(rsp, payload_len, $tlv_id, $MAX_VALUE, out->$value);
"    if (ret != tGOBI_ERR_NONE) {
"        RLOGE("%s: unable to collect $value", __FUNCTION__);
"        goto end;
"    }
"    out->$value_len = strlen(out->$value);
" ---
let @m='vt yOec_mtoh(&(jjpa), siz<e€kb€kbeof(jjpa),jj ojhvF lyko&(jjpa), sizeof(jjpa));jB'
let @u='fn/data:€kb€kb€kb€kb€kb€kbdata_.*= sizef(lvi)ykOCHECK_BN€kb€kbUNPACK_TLV_SIZE(jjpa);jjjBv/}ddd'
let @p='fnQMI_.*tlv_.*;veyji		tlv_sz = jjpbisizeof(jjA);jBvjjjjjjjcCHEK€kbCK_PACK_TLV_SIZE(jjatlv_sz, hdr_sz, payload_len, *len);'
let @c='fnec_vlccopyjjbveUf(lvldf,lvf,dJlvldf)dlvf)dF)dl'
let @h='ouint32_t hdr_sz;uint16_t tlv_sz;fntimeot€kbut = ohdr_si€kbz = sizeof(QMI_raw_content_header_t);'
let @m='fnif (!hdr)kf(lvi)yOFIND_MANDATORY_TLV(jjpa, hdr);jBv/}ddd'
