const path = require("path")

module.exports = {
  entry: [
    "./source/assets/main.js"
  ],
  output: {
    filename: "bundle.js",
    path: path.resolve(__dirname, ".tmp", "dist")
  }
}
