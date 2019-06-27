ULONG function_unpack(const ULONG payloadLen, const BYTE *pPayload, structure_t *out)
{
  std::map <UINT8, const sQMIRawContentHeader *> tlvs = GetTLVs( &pPayload[0], payloadLen );

  std::map <UINT8, const sQMIRawContentHeader *>::const_iterator pIter = tlvs.find( 0x01 );
  if (pIter != tlvs.end())
  {
    const sQMIRawContentHeader * pTmp = pIter->second;
    ULONG tlvLen = (ULONG)pTmp->mLength;
    ULONG dsLen = (ULONG)sizeof( A );
    if (tlvLen < dsLen)
    {
      return eGOBI_ERR_BUFFER_SZ;
    }

    pTmp++;
    const A* ptr =
        (const A*) pTmp;

    memcpy(out, ptr, sizeof(A));
  }

  return eGOBI_ERR_NONE;
}
