ULONG function_pack(ULONG *pPayloadLen, UINT8 *pPayload)
{
  UINT8 *payloadPtr = pPayload;

  sQMIRawContentHeader * pTLV = (sQMIRawContentHeader *)payloadPtr;

  pTLV->mTypeID = 0x01;
  pTLV->mLength = (UINT16)sizeof( A );
  payloadPtr += sizeof(sQMIRawContentHeader);

   A  *pReq =
    ( A  *) payloadPtr;

  pReq-> = ;

  payloadPtr += sizeof(  A  );

  *pPayloadLen = (ULONG)payloadPtr - (ULONG)pPayload;

  return eGOBI_ERR_NONE;
}
