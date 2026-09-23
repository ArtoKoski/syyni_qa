"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
var express_1 = require("express");
var cors_1 = require("cors");
var results_1 = require("./routes/results");
var app = (0, express_1.default)();
app.use((0, cors_1.default)());
app.use(express_1.default.json());
app.use("/api/results", results_1.default);
var PORT = 3000;
app.listen(PORT, function () {
    console.log("Server running on port ".concat(PORT));
});
