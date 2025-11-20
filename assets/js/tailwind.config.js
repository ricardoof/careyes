module.exports = {
  content: [
    "./**/*.js",
    "../css/**/*.css",
    "../../lib/careyes_web/**/*.*(ex|heex)"
  ],

  theme: {
    extend: {
      colors: {
        "cy-font": "#525259",
        "cy-purple": "#6e45e2",
        "cy-blue": "#88d3ce",
      }
    },
  },

  plugins: [] 
}