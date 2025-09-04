local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node


return {
	s("trig", t("loaded!!")),
	s("tcg", {
		t('<span style="green-bold">'),
		i(1, "#"),
		t("</span>"),
		i(0)
	}),
}
