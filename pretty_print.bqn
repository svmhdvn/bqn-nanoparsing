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
  connectors←"─┌┬┐│┴├┼┤│" # vertical
  spaces←1 # vertical
  d← Depths p
  maxDepth←⌈´d
  results←labels
  # TODO check for maxDepth=0

  DoFamily←{
    # 𝕨: parent node
    # 𝕩: rendered children
    widths←?
  }
  # Render and record all nodes
  # whose children have depth 𝕩
  DoLayer←{
    # 𝕨: depth at which to handle nodes
    i←/d=𝕩
    ·←p DoFamily(⊐⊸⊔)○(i⊸⊏)
  }
}
