#include "autocomplete.h"

char *keywords[] = {
  "exit",
  "test",
    NULL
};

char **
keyword_completion(const char *text, int start, int end)
{
    rl_attempted_completion_over = 1;
    return rl_completion_matches(text, keyword_generator);
}

char *
keyword_generator(const char *text, int state)
{
    static int list_index, len;
    char *keyword;

    if (!state) {
        list_index = 0;
        len = strlen(text);
    }

    while ((keyword = keywords[list_index++])) {
        if (strncmp(keyword, text, len) == 0) {
            return strdup(keyword);
        }
    }

    return NULL;
}
