del all_files.txt
for %%D in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
    if exist %%D:\ (
        echo Scanning drive %%D: ...
        dir %%D:\ /a-d /s /b 
    )
) >> all_files.txt