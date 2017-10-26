#ifndef GETLINE_H
#define GETLINE_H 

#include <stdio.h>

static ssize_t senguard_getline(char **lineptr, size_t *n, FILE *stream)
{
    char *ptr;

    ptr = fgetln(stream, n);

    if (ptr == NULL) {
        return -1;
    }

    /* Free the original ptr */
    if (*lineptr != NULL) free(*lineptr);

    /* Add one more space for '\0' */
    size_t len = n[0] + 1;

    /* Update the length */
    n[0] = len;

    /* Allocate a new buffer */
    *lineptr = (char*)malloc(len);

    /* Copy over the string */
    memcpy(*lineptr, ptr, len-1);

    /* Write the NULL character */
    (*lineptr)[len-1] = '\0';

    /* Return the length of the new buffer */
    return len;
}
#endif
