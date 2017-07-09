function Component()
{
    // constructor
}

Component.prototype.isDefault = function()
{
    // select the component by default
    return true;
}

function createShortcuts()
{
    var windir = installer.environmentVariable("WINDIR");
    if (windir === "") {
        QMessageBox["warning"]( "Error" , "Error", "Could not find windows installation directory");
        return;
    }

    var cmdLocation = windir + "\\system32\\cmd.exe";
    component.addOperation("CreateShortcut",
                           cmdLocation,
                           "@StartMenuDir@/11_3_toolbar.lnk",
			   // change MyApp.bat with the path to your Application
                           "/A /Q /K SET PATH=@TargetDir@\\bin;%PATH% & MyApp.bat");

    component.addOperation("Execute",
                           ["@TargetDir@\\bin\\gdk-pixbuf-query-loaders.exe",
                            "--update-cache"]);

    component.addOperation("Execute",
                           ["@TargetDir@\\bin\\glib-compile-schemas.exe",
                            "@TargetDir@\\share\\glib-2.0\\schemas"]);

    component.addOperation("Execute",
                           ["@TargetDir@\\bin\\gtk-update-icon-cache-3.0.exe",
                            "@TargetDir@\\share\\icons\\hicolor"]);

}

Component.prototype.createOperations = function()
{
    component.createOperations();
    createShortcuts();
}
