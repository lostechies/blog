---
id: 729
title: Serialization madness, Unicode edition
date: 2013-02-13T14:22:56+00:00
author: Jimmy Bogard
layout: post
guid: http://lostechies.com/jimmybogard/?p=729
dsq_thread_id:
  - "1081196219"
categories:
  - Rant
---
Yesterday we were debugging an issue in XML serialization where only a portion of the document was getting deserialized before we encountered an error. It was a strange error, where it looked like when reading the XML the XML document abruptly ended. Chasing this problem down, however, was a bit of a struggle. Here’s the pipeline that got executed:

  * Base 64 Decode
  * GZip Decompress
  * UTF8 Decode
  * JSON Deserialize
  * XML Serialize
  * UTF8 Encode
  * (Send message along the wire)
  * UTF8 Decode
  * XML Deserialize

Somewhere along the line, the Unicode “NUL” character crept in (U+0000) and the XML deserializer interpreted this as “end of document”. But tracing this back was obviously a bit of a challenge. We found the problem in the XML deserialization step, which was originally derived from an UTF8-encoded version of an XML-serialized object, that originated from a JSON-deserialized, UTF8-decoded, gzip-decompressed, Base-64 decoded string (that was also originally embedded in an XML document).

The fix came in something simple – something along the way treated “nulls” as Unicode null for serialization, so it was really just a matter of replacing the text in the JSON string for Unicode null (u+0000) with the text “null” for actual JSON null, and everything worked again.

It all worked, but I wonder if we could have fit a couple more steps in the pipeline, maybe encryption/signing for fun?