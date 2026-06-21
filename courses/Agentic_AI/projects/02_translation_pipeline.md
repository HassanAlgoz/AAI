# Book Translation Pipeline

## Overview

Goal: translate an entire technical textbook to Arabic (مع تشكيل تام).

Scope: pick any textbook from [OpenStax](https://openstax.org/subjects) (Open license).

- Phase 1 Convert the PDF into markdown; a more open and accessible and editable format.
- Phase 2 Translate to Arabic.
- Phase 3 Render as PDF textbook.

Note: diagrams and pictures also need to be processed to fit Arabic textbooks.

## Revise and Optimize

Quality of output should match the quality of the input.

Evaluate translation accuracy based on research in Arabic technical and scientific translation.

Be creative to come up with other reviewal criteria. Example: change examples to adapt to culture; no beer, adapt to weather and local sites and cuisines, and so on. You should come up with other criteria for evaluation.

Goods (Dos) and Bads (Don'ts).

Use GEPA or other optimizers to tune the prompts of the pipeline to score higher on this evaluation.

## Bonus

Scale this pipeline to the rest of the OpenStax library; while maintaining quality.

### Explanatory Commentary

Writers in their respective fields often write **explanatory commentary** attatched to central books in the field. Common in academia, this form of writing often inserts then explains snippets of the original content. One after another. Until the whole book is done. Word for word.

Your task is to do just that. Provide an explanation block for each part of the text, piece by piece.

However, don't explain things that are already clear, and don't repeat explaining things that have already been explained, or about to be explained. Etc. You can get creative here in the best way it helps people learn.

Also, add markers to distinguish insertions from the original content itself, to uphold the virtue of honesty.
