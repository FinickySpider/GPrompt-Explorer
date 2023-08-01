# GPrompt Explorer


### **Excuse the messy code, I'll clean it up soon!**


## Overview
GPrompt Explorer is a simple GUI to view large amounts of prompts in a organized and searchable UI.

## Features

- **Search & Filter:** Find specific prompts using search criteria and filters.
- **Preview Prompts:** View the content of individual prompts directly within the application.
- **Prompts are Sorted Into Tiers:** Users can store their prompts in a series of tiers based on what folder they store the prompt in.
- **Token Cost** Token cost estimator.

## Usage
1. Open GPrompt Explorer-v.exe
2. The folder should autoselect and load all prompts as long as the dir structure is maintained. Otherwise you can select the folder containing the prompts with by pressing the `Folder` button.
3. Use the navigation panel to browse through the prompts.
4. Double-click a prompt to preview its content.
5. You can use the search field to narrow down which prompts are visible, just erase the search when you're done and it wil repopulate automatically.
6. You can hit the `Clipboard` buttton to copy the contents of the loaded prompt to the clipboard. (Note: The prompt field is editable but no changes are saved in the source file.
7. If you add edit or add new prompts while it's running you can press F5 or load the folder again to repopulate the panel.
8. Pressing the `Estimate` will take everything in the prompts display box and estimate how many tokens it is total. Be patient it can take up to 10 seconds sometimes depending on the length of the prompt. I'll add a indicator that shows if it's loading soon.

## GUI Elements

1. Location to the prompts folder.
2. Button to open a folder dialog to select a custom folder (Should automatically select the proper folder as long as it's in the same dir as the exe).
3. Search to filter the List of prompts.
4. Selected prompt Name.
5. Displays the contents of the prompt. It is editable but doesn't save any changes to the prompt.
6. Copies the contents of the edit box to your clipboard.
7. Display Image to go along with prompt for fun. :)
8. Displays all the loaded prompts. Double Click to open one.
9. Button to estimate amount of tokens.
10. Token amount total.
11. The estimated string broken down into thier individual token ID's 

![image](https://github.com/FinickySpider/GPrompt-Explorer/assets/8377070/da2ed1d4-6393-4f96-8afd-5356946201d6)







## Installation
1. Download the latest release from [GitHub](https://github.com/FinickySpider/GPrompt-Explorer/releases/tag/Alpha).
2. Extract the ZIP file.
3. Run `GPrompt Explorer-v.exe` (Windows Only Sorry)

## Adding Your Own Custom Prompts

To add your custom prompts to GPrompt Explorer, follow the guidelines below:

### File Location
- Files will only be recognized if placed in the following directory structure: `"App Dir\Prompts\Tier \"`

### Required Files
1. **PNG File:** An image file that represents the prompt.
 - If you do not have a custom image, you may copy the `default.png` file and rename it to match your prompt.
2. **TXT File:** A text file containing the prompt's content.
 - Ensure the TXT file has the exact same name as the PNG file.

**Note:** It might work without an image, but this has not been tested. Using a PNG file is advised for consistency with other prompts.

## Known Bugs
- When sorting without a prompt selected the display image will shrink down. Should fix it self as soon as you select a new prompt from the list though. It's purely visual.

## To-Do
Here's a list of features and enhancements I'm currently working on:
- **Custom Folder structure:**  Custom storage format for storing prompts so it's less restrictive.
- **Save Edits:** Option to save prompts you edit within the explorer.
- **UI Resizing:** Resizing the window.
- **Error Handling:** Need to go through and add lots of error handling and code comments.

## Upcoming Changes/Wishlist
Some things I plan to add as time allows.
- **Add ChatGPT Utilities:** To enhance prompt accessibility in ChatGPT, Implementing autocomplete-style shortcuts. Users can type part of the prompt name and press tab, loading and pasting the desired prompt without needing to go into the explorer and Other things of this nature. Suggestions welcome.
- **Integration with Cloud Services:** Enabling synchronization with popular cloud storage providers could be cool
- **More Attributes** Allowing to sort and view prompts by other things then just name and tier.


## Support & Feedback
For support, bug reporting, or feedback, please [create an issue](https://github.com/FinickySpider/GPrompt-Explorer/issues) on my GitHub page.


---

Enjoy exploring your prompts with GPrompt Explorer!

