

/* function that remove path and keep filename without extension */
function getFileNameFromPath(path) {
    return path.split('\\').pop().split('/').pop().split('.')[0];
}
