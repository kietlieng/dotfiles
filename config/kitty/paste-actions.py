def filter_paste(text: str) -> str:
    # Normalize line endings so stray carriage returns (\r) don't reach the
    # shell and render as the ␍ control-picture glyph at the fish prompt.
    # CRLF -> LF, then any remaining lone CR -> LF.
    return text.replace('\r\n', '\n').replace('\r', '\n')
