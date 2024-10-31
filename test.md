# Title

This is an example md file for testing playbook.sh.

## Example heading 

this is some text

## Run some bash example 1

```bash
echo "bash example 1"
```

## Another heading

Try skipping this section to check skipping the code execution works...

```bash
echo "skip this one to check skipping code works"

```

## Call a python script

```bash
python3 hello.py
```

## Longer running bash example
 
some more text and some code to execute with a command that will take some time

```bash
brew update
```

### Go to a webpage
 
Go to google in your default browser

```bash
open https://google.com
```
 
## Some python in a codeblock

This is a code block with python code so it shouldn't be run until playbook supports python as well as bash:

```python
print("hello")
```

# finish

can I skip this?
```bash
echo "I ran"
```
