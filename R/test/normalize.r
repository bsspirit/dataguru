normalize <- function (data) {
    (data - min(data))/(max(data) - min(data))
}