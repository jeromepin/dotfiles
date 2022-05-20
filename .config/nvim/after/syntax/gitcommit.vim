syn match   gitcommitSummary	"^.*\%<101v." contained containedin=gitcommitFirstLine nextgroup=gitcommitOverflow contains=@Spell
