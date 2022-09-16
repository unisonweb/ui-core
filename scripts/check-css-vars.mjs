#!/usr/bin/env node

// Combine all CSS files and check if CSS variables that are referenced
// actually are defined somewhere in all the files.
// Currently does not verify that the variables referenced are in scope.
//
// TODO: Don't warn for var usages that have fallbacks
import glob from "glob";
import fs from "fs/promises";

glob("src/**/*.css", (err, files) => {
  if (err) console.error(err);

  Promise.all(files.map((f) => fs.readFile(f, "utf-8")))
    .then((css) => css.reduce((acc, s) => acc.concat(s)))
    .then((allCss) => {
      const varsReferencedRegEx = /var\(--.*?\)/g;
      const allVarsReferenced = allCss
        .match(varsReferencedRegEx)
        .filter((v, i, l) => l.indexOf(v) === i)
        .reduce((acc, s) => {
          if (s.includes(",")) {
            const vars = s
              .replace(/var\(/g, "")
              .replace(/\)/g, "")
              .split(",")
              .map((s) => s.trim())
              .filter((s) => s.startsWith("--"));
            return acc.concat(...vars);
          } else {
            return acc.concat(
              s.replace(/var\(/g, "").replace(/\)/g, "").trim()
            );
          }
        }, []);

      const varsDefinedRegex = /--.*?\:/g;
      const allVarsDefined = allCss
        .match(varsDefinedRegex)
        .map((s) => s.trim().replace(/:/g, ""))
        .filter((v, i, l) => l.indexOf(v) === i);

      const missingVars = allVarsReferenced.reduce((acc, v) => {
        if (allVarsDefined.includes(v)) {
          return acc;
        } else {
          return acc.concat(v);
        }
      }, []);

      if (missingVars.length > 0) {
        console.log(
          `🚨 Error! ${missingVars.length} undefined CSS variables used:`
        );
        console.log("");
        console.log(missingVars.join("\n"));
        process.exit(1);
      } else {
        console.log("✅ Yay! All CSS variables are accounted for");
      }
    });
});
