```shell
#   The numbers used can be:
#   * n     : An integer
#   * '*'   : Every/Any option
#   * n1-n2 : Ranges of numbers e.g 1-5 aka Monday to Friday in the day field
#
#   +---------------- Minute when the process will be started [0-59]
#   |  +------------- Hour when the process will be started [0-23]
#   |  |  +---------- Day of the month when the process will be started [1-31]
#   |  |  |  +------- Month of the year when the process will be started [1-12]
#   |  |  |  |  +---- Weekday when the process will be started [0-6] [0|7 is Sunday]
#   |  |  |  |  |
#   *  *  *  *  *  <command to be executed>
#
#   Keywords:
#   * Can be used as a shortcut to entering the numbers.
#     * e.g.
#     * @daily         <command to be executed>
#
#   @yearly   = 0  0  1  1  *
#   @annually = 0  0  1  1  *
#   @monthly  = 0  0  1  *  *
#   @weekly   = 0  0  *  *  0
#   @daily    = 0  0  *  *  *
#   @midnight = 0  0  *  *  *
#   @hourly   = 0  *  *  *  *
#   @reboot   = [Special setting, runs at startup]
```
