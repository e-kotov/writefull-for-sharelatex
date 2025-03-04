**WARNING: This script will probably never work anymore, as the original extension was taken down, please see the details in [this issue](https://github.com/e-kotov/writefull-for-sharelatex/issues/3).**

---

This shell script patches the [Writefull for Overleaf](https://chromewebstore.google.com/detail/writefull-for-overleaf/edhnemgfcihjcpfhkoiiejgedkbefnhg) Chrome extension to work with any self-hosted ShareLaTeX server on custom domain. It replaces the icons of the extension so that you don't mix it up with the original extension and can use the original with [https://www.overleaf.com/](https://www.overleaf.com/).

# Supported OS and browsers:

- macOS / Linux

- Google Chrome / Chromium / Chromium installed from `snap`

The script detects the OS automatically and searches the extension folders automatically.

# How to use it:

1. Go to https://chromewebstore.google.com/detail/writefull-for-overleaf/edhnemgfcihjcpfhkoiiejgedkbefnhg and install the latest version of `Writefull for Overleaf` in your Chrome browser.

2. Open Terminal and clone this repository:

```{bash}
git clone https://github.com/e-kotov/writefull-for-sharelatex.git
cd writefull-for-sharelatex
```

3. Set permissions to run the script:

```{bash}
chmod +x ./writefull_patch.sh
```

4. Run the script:

```{bash}
./writefull_patch.sh
```

- You will be prompted to provide the domain name of your ShareLaTeX server. The default is `sharelatex.com`, you may be providing something like `sharelatex.your-org-name.fr`.

The script assumes that you have the `Writefull for Overleaf` extension installed in the `Default` Google Chrome profile. If that is not the case, it will scan all other Gogole Chrome profiles in your home folder for the installed extension.

The default output of the script is in your home Downloads folder: `~/Downloads/writefull_chrome_patched`.

5. Once you get "Modification completed." message, proceed to manually install the patched extension in Chrome:

    - In Chrome open `chrome://extensions/`

    - Enable developer mode in the top right corner.

    - Click 'Load unpacked' button in the top right corner.
    
    - Select the `~/Downloads/writefull_chrome_patched` folder

    - Ignore that the installation shows an erorr about the manifest version.

That's it, enjoy [Writefull](https://www.writefull.com/) on your self-hosted ShareLaTeX server on custom domain.

