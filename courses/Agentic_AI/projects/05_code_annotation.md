# Code Annotation

Writers in their respective fields often write explanatory commentary attatched to central books in the field. Common in academia, this form of writing often inserts then explains snippets of the original content. One after another. Until the whole book is done. Word for word.

Goal: explain an entire codebase, module by module, line by line, given only the GitHub repo url.

For an example, you can look at: [UNet](https://nn.labml.ai/unet/index.html) and it's [source code](https://github.com/labmlai/annotated_deep_learning_paper_implementations/blob/master/labml_nn/unet/__init__.py) by [labml.ai](https://labml.ai/#nn).

Remember, not all repos are equal. Some repos are libraries, some are frameworks, and some are software projects.

Must do:

- Ground explanation in official documentation guides (guard against hallucination)
- Don't over-explain; keep it concise and bite-sized
- Arabic translation should be available
- When modules/classes/methods/functions within the codebase are mentioned; they should be clickable (link)
- Must include search by module/class/method/function or any free-text to find the information quickly

Should be easy to navigate, clear to ready and understand.

Feel creative in how to better explain a codebase.
