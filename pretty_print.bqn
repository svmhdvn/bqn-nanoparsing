#!/usr/bin/env BQN

⟨
  Depths
  PrettyPrint
⟩⇐

Depths ← {
  p←𝕩 # input parent vec
  StepUp←{ 𝕊 d‿prev‿cur:
    q ← cur ⊏ p
    (d+cur≠q)‿cur‿q
  }
  ⊑ StepUp•_while_(≢´1⊸↓) (𝕩≠⊸⥊0)‿⟨⟩‿(↕≠𝕩)
}

PrettyPrint ← { labels 𝕊 p:
  # labels: vector of character matrices giving labels for each node
  # p: parent vector
  connectors←"─┌┬┐│┴├┼┤│" # box-drawing characters (vertical)
  spaces←1 # num spaces to pad between subtrees (vertical)
  d←Depths p
  maxDepth←⌈´d
  results←labels
  # TODO check for maxDepth=0

  DoFamily←{
    # 𝕨: parent node
    # 𝕩: rendered results of children

    # widths of each rendered child
    widths←(1⊑≢)¨𝕩
    # eventual width of the rendered tree 
    width←spaces-˜+´spaces+widths                #  wwwwwww
    # centres of each rendered sub-tree
    centres←(+´0∾¯1↓spaces+widths)+¯1+⌈widths÷2                                       #  ∘ss∘ss∘
    # header to be decorated
    result←width⥊' '                                                                  # '       '
    # add horizontal bar
    result (⊑connectors)¨⌾(((⊢ ⊢∘/˜ ((¯1⊑centres)>⊢) ∧ (⊑centres) < ⊢) ↕width)⊸⊏)↩    # ' ───── '
    # left end of bar
    result (1⊑connectors)¨⌾((⊑centres)⊸⊏)↩                                            # '┌───── '
    # right end of bar
    result (3⊑connectors)¨⌾((¯1⊑centres)⊸⊏)↩                                          # '┌─────┐'
    # connectors to intermediate children
    result (2⊑connectors)¨⌾((¯1↓1↓centres)⊸⊏)↩                                        # '┌──┬──┐'
    # if there's only one child, just make it a lone upstrike
    result (4⊑connectors)¨⌾(((1=≠centres)⥊⊑centres)⊸⊏)↩
    # index of the centre of the rendered tree
    centre←¯1+⌈width÷2
    # connector to the parent                                                         #     ∘
    result (((¯5↓connectors)⊐⊢)⊏5↓connectors˙)⌾(centre⊸⊏)↩                            # '┌──┼──┐'
    # pad labels, join under header
    result ∾↩ (-spaces) ↓⎉2 ⊑ ∾⎉1 / ∾⎉1∘(spaces⥊' ')⎉2¨ 𝕩 ↑¨˜ ⌈´≠¨𝕩
    # parent's label
    parentResult←𝕨⊑results
    # width of the parent's label
    parentWidth←1⊑≢parentResult
    # centre of the parent's label
    parentCentre←¯1+⌈parentWidth÷2
    # pad and recentre text so far if it's less wide
    result ((centre-parentCentre) ⌽ parentWidth ↑⎉1 ⊢)⍟(width<parentWidth)↩
    # pad and recentre parent label if it's less wide
    parentResult ((parentCentre-centre) ⌽ width ↑⎉1 ⊢)⍟(width>parentWidth)↩
    # add parent label
    result ↩ result ∾ parentResult
    # record the result
    results (⊑result)⌾(𝕨⊸⊏)↩
  }
  # Render and record all nodes
  # whose children have depth 𝕩
  DoLayer←{
    # 𝕨: depth at which to handle nodes
    i←/d=𝕩
    # TODO is (⍷∘⊣ F¨ ⊐⊸⊔) the best way to
    # emulate APL's key operator for function F?
    # It seems inefficient due to multiple deduplication
    # passes.
    ·←p (⍷∘⊣ DoFamily¨ ⊐⊸⊔)○(i⊸⊏) results
  }
  ·←DoLayer¨⌽1+↕maxDepth
  results/˜p=↕≠p
}

# vertical
PPV←{
  𝕨←'∘'
  ((≢𝕩) ⥊ ⍉∘⍪∘⍕¨ 𝕨) PrettyPrint 𝕩
}

# horizontal
# TODO
#PPH←{
#  ⍺←'∘'
#  ⍉¨((≢⍵)⍴  ⍪⍤⍕¨'∘'@(0=≢¨)⍺)('│┌├└─┤┬┼┴─'_PrettyPrint_ 0)⍵
#}

