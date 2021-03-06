"use strict"

const {DatabaseError} = require('../../common/yadamuException.js')

class FileError extends DatabaseError {
  constructor(cause,stack,path) {
    super(cause,stack,path);
  }
}

class FileNotFound extends FileError {
  constructor(cause,stack,path) {
    super(cause,stack,path);
  }
}

class DirectoryNotFound extends FileError {
  constructor(cause,stack,path) {
    super(cause,stack,path);
  }
}

module.exports = {
  FileError
, FileNotFound
, DirectoryNotFound
}