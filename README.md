### Тестовое задание на позицию junior dev/ops engineer, Лебедев А. И.    

  


- Я решил объединить задания 1 и 3 в один стэк и попробовать выполнить все используя используя Ansible.
  Машины разверну в virtual box используя vagrant. Можно было бы сделать все это в yandex cloud и через Terraform, но, считаю, что пока это весьма тернистый путь и давайте исходить из текущих задач.

- Vagrantfile простой. Развернем две машины на Debian10:

```
config.vm.define "vita1" do |vita1|
    vita1.vm.hostname = "vita1"
    vita1.vm.box = "generic/debian10"
    vita1.vm.network "public_network", bridge: "Intel(R) Dual Band Wireless-AC 8260"
    config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = "1"
  end
end


config.vm.define "vita2" do |vita2|
    vita2.vm.hostname = "vita2"
    vita2.vm.box = "generic/debian11"
    vita2.vm.network "public_network", bridge: "Intel(R) Dual Band Wireless-AC 8260"
    config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
    vb.cpus = "2"
  end
end
```


На первой машине развернем Ansible, на второй будем разворачивать необходимую по условию инфраструктуру.  

- Запишем адрес необходоимой машины в inventory, создадим и прокинем ssh-ключ (*ssh-copy-id -i vkey.pub userid@ip*) и попробуем проверить соединение. И вот, о чем я и говорил:

![false](img/false.JPG)  

Я вижу, что на второй машине есть python, но ансибловый пинг валится в ошибку. Я сталкивался с этим и на яндекс клауде и так и не понял в чем дело. Но, ансибл имеет такой модуль - raw. Собственно, как я понял, им, в основном, такую проблему и решают. Допишем одну строчку в inventory и сделаем *raw_playbook.yaml*.  
  
Собственно, после этого связь появляется и все ок. Я не знаю, что это за баг. У кого не спрашивал, никто не сталкивался. Возможно, я что-то делаю не правильно:    

![raw](img/raw.JPG)    

- Закачаем пустую структуру ansible-galaxy, чтобы выполнить все одной ролью, ну и напишем плэйбук, собственно (все файлы и структура доступны в данном гите):

```
root@vita1:/home/vagrant/vita_proj# ansible-playbook vita_copy.yaml

PLAY [server] *******************************************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************************
ok: [10.22.97.60]

TASK [vita_copy : Create parent directory] **************************************************************************************************************************************************************************************************
ok: [10.22.97.60]

TASK [vita_copy : Create subdirectories] ****************************************************************************************************************************************************************************************************
ok: [10.22.97.60] => (item=/home/vagrant/workdir/codes)
ok: [10.22.97.60] => (item=/home/vagrant/workdir/tests)
ok: [10.22.97.60] => (item=/home/vagrant/workdir/prod)

TASK [vita_copy : Put random bash-scripts1 to codes directory] ******************************************************************************************************************************************************************************
ok: [10.22.97.60]

TASK [vita_copy : Put random bash-scripts2 to codes directory] ******************************************************************************************************************************************************************************
ok: [10.22.97.60]

TASK [vita_copy : Copy directory using copy module] *****************************************************************************************************************************************************************************************
ok: [10.22.97.60]

TASK [vita_copy : Copy files using copy module] *********************************************************************************************************************************************************************************************
ok: [10.22.97.60] => (item=randomfile1)
ok: [10.22.97.60] => (item=randomfile2)
ok: [10.22.97.60] => (item=randomfile3)
ok: [10.22.97.60] => (item=randomfile4)

TASK [vita_copy : Check created folders and files] ******************************************************************************************************************************************************************************************
changed: [10.22.97.60] => (item=/home/vagrant/workdir)
changed: [10.22.97.60] => (item=/home/vagrant/workdir/codes)
changed: [10.22.97.60] => (item=/home/vagrant/workdir/tests)
changed: [10.22.97.60] => (item=/home/vagrant/workdir/prod)

TASK [vita_copy : Out_files] ****************************************************************************************************************************************************************************************************************
ok: [10.22.97.60] => {
    "msg": "####Созданные файлы и каталоги####"
}

TASK [vita_copy : Out_result] ***************************************************************************************************************************************************************************************************************
ok: [10.22.97.60] => {
    "result": {
        "changed": true,
        "msg": "All items completed",
        "results": [
            {
                "_ansible_ignore_errors": true,
                "_ansible_item_label": "/home/vagrant/workdir",
                "_ansible_item_result": true,
                "_ansible_no_log": false,
                "_ansible_parsed": true,
                "changed": true,
                "cmd": [
                    "ls",
                    "/home/vagrant/workdir"
                ],
                "delta": "0:00:01.006068",
                "end": "2023-06-22 11:29:24.814663",
                "failed": false,
                "invocation": {
                    "module_args": {
                        "_raw_params": "ls \"/home/vagrant/workdir\"",
                        "_uses_shell": false,
                        "argv": null,
                        "chdir": null,
                        "creates": null,
                        "executable": null,
                        "removes": null,
                        "stdin": null,
                        "warn": true
                    }
                },
                "item": "/home/vagrant/workdir",
                "rc": 0,
                "start": "2023-06-22 11:29:23.808595",
                "stderr": "",
                "stderr_lines": [],
                "stdout": "codes\nprod\ntests",
                "stdout_lines": [
                    "codes",
                    "prod",
                    "tests"
                ]
            },
            {
                "_ansible_ignore_errors": true,
                "_ansible_item_label": "/home/vagrant/workdir/codes",
                "_ansible_item_result": true,
                "_ansible_no_log": false,
                "_ansible_parsed": true,
                "changed": true,
                "cmd": [
                    "ls",
                    "/home/vagrant/workdir/codes"
                ],
                "delta": "0:00:00.003848",
                "end": "2023-06-22 11:29:25.175921",
                "failed": false,
                "invocation": {
                    "module_args": {
                        "_raw_params": "ls \"/home/vagrant/workdir/codes\"",
                        "_uses_shell": false,
                        "argv": null,
                        "chdir": null,
                        "creates": null,
                        "executable": null,
                        "removes": null,
                        "stdin": null,
                        "warn": true
                    }
                },
                "item": "/home/vagrant/workdir/codes",
                "rc": 0,
                "start": "2023-06-22 11:29:25.172073",
                "stderr": "",
                "stderr_lines": [],
                "stdout": "script1.sh\nscript2.sh",
                "stdout_lines": [
                    "script1.sh",
                    "script2.sh"
                ]
            },
            {
                "_ansible_ignore_errors": true,
                "_ansible_item_label": "/home/vagrant/workdir/tests",
                "_ansible_item_result": true,
                "_ansible_no_log": false,
                "_ansible_parsed": true,
                "changed": true,
                "cmd": [
                    "ls",
                    "/home/vagrant/workdir/tests"
                ],
                "delta": "0:00:00.004912",
                "end": "2023-06-22 11:29:25.520529",
                "failed": false,
                "invocation": {
                    "module_args": {
                        "_raw_params": "ls \"/home/vagrant/workdir/tests\"",
                        "_uses_shell": false,
                        "argv": null,
                        "chdir": null,
                        "creates": null,
                        "executable": null,
                        "removes": null,
                        "stdin": null,
                        "warn": true
                    }
                },
                "item": "/home/vagrant/workdir/tests",
                "rc": 0,
                "start": "2023-06-22 11:29:25.515617",
                "stderr": "",
                "stderr_lines": [],
                "stdout": "randomdir",
                "stdout_lines": [
                    "randomdir"
                ]
            },
            {
                "_ansible_ignore_errors": true,
                "_ansible_item_label": "/home/vagrant/workdir/prod",
                "_ansible_item_result": true,
                "_ansible_no_log": false,
                "_ansible_parsed": true,
                "changed": true,
                "cmd": [
                    "ls",
                    "/home/vagrant/workdir/prod"
                ],
                "delta": "0:00:00.003558",
                "end": "2023-06-22 11:29:25.859104",
                "failed": false,
                "invocation": {
                    "module_args": {
                        "_raw_params": "ls \"/home/vagrant/workdir/prod\"",
                        "_uses_shell": false,
                        "argv": null,
                        "chdir": null,
                        "creates": null,
                        "executable": null,
                        "removes": null,
                        "stdin": null,
                        "warn": true
                    }
                },
                "item": "/home/vagrant/workdir/prod",
                "rc": 0,
                "start": "2023-06-22 11:29:25.855546",
                "stderr": "",
                "stderr_lines": [],
                "stdout": "randomfile1\nrandomfile2\nrandomfile3\nrandomfile4",
                "stdout_lines": [
                    "randomfile1",
                    "randomfile2",
                    "randomfile3",
                    "randomfile4"
                ]
            }
        ]
    }
}

TASK [vita_copy : Check content] ************************************************************************************************************************************************************************************************************
changed: [10.22.97.60] => (item=/home/vagrant/workdir/codes/script1.sh)
changed: [10.22.97.60] => (item=/home/vagrant/workdir/codes/script2.sh)

TASK [vita_copy : Out_code] *****************************************************************************************************************************************************************************************************************
ok: [10.22.97.60] => {
    "msg": "####Содержимое файлов со скриптами####"
}

TASK [vita_copy : Out_code_result] **********************************************************************************************************************************************************************************************************
ok: [10.22.97.60] => {
    "resultcode": {
        "changed": true,
        "msg": "All items completed",
        "results": [
            {
                "_ansible_ignore_errors": true,
                "_ansible_item_label": "/home/vagrant/workdir/codes/script1.sh",
                "_ansible_item_result": true,
                "_ansible_no_log": false,
                "_ansible_parsed": true,
                "changed": true,
                "cmd": [
                    "cat",
                    "/home/vagrant/workdir/codes/script1.sh"
                ],
                "delta": "0:00:00.004077",
                "end": "2023-06-22 11:29:26.434841",
                "failed": false,
                "invocation": {
                    "module_args": {
                        "_raw_params": "cat \"/home/vagrant/workdir/codes/script1.sh\"",
                        "_uses_shell": false,
                        "argv": null,
                        "chdir": null,
                        "creates": null,
                        "executable": null,
                        "removes": null,
                        "stdin": null,
                        "warn": true
                    }
                },
                "item": "/home/vagrant/workdir/codes/script1.sh",
                "rc": 0,
                "start": "2023-06-22 11:29:26.430764",
                "stderr": "",
                "stderr_lines": [],
                "stdout": "#!/bin/bash\n# Generate a randomly based range defined by the user\n\n#Take the lower and the upper value from the user\necho \"Enter the minimum value:\"\nread minimum\necho \"Enter the maximum value:\"\nread maximum\n\n#Check the taken values are valid\nif [[ $maximum < $minimum ]]; then\n    echo \"Maximum value can't be lower than minimum value\"\n    exit 1\nfi\n\n#Find out the difference between the numbers\ndiff=$(($maximum-$minimum))\n\n#Check the difference value\nif [[ $diff == 1 ]]; then\n    echo \"The range of numbers must be more than 1\"\n    exit 1\nfi\n\n#Generate the random number\nrandomNumber=$(($minimum + $RANDOM % $maximum))\n#Print the generated number\necho \"The generated random number is: $randomNumber\"",
                "stdout_lines": [
                    "#!/bin/bash",
                    "# Generate a randomly based range defined by the user",
                    "",
                    "#Take the lower and the upper value from the user",
                    "echo \"Enter the minimum value:\"",
                    "read minimum",
                    "echo \"Enter the maximum value:\"",
                    "read maximum",
                    "",
                    "#Check the taken values are valid",
                    "if [[ $maximum < $minimum ]]; then",
                    "    echo \"Maximum value can't be lower than minimum value\"",
                    "    exit 1",
                    "fi",
                    "",
                    "#Find out the difference between the numbers",
                    "diff=$(($maximum-$minimum))",
                    "",
                    "#Check the difference value",
                    "if [[ $diff == 1 ]]; then",
                    "    echo \"The range of numbers must be more than 1\"",
                    "    exit 1",
                    "fi",
                    "",
                    "#Generate the random number",
                    "randomNumber=$(($minimum + $RANDOM % $maximum))",
                    "#Print the generated number",
                    "echo \"The generated random number is: $randomNumber\""
                ]
            },
            {
                "_ansible_ignore_errors": true,
                "_ansible_item_label": "/home/vagrant/workdir/codes/script2.sh",
                "_ansible_item_result": true,
                "_ansible_no_log": false,
                "_ansible_parsed": true,
                "changed": true,
                "cmd": [
                    "cat",
                    "/home/vagrant/workdir/codes/script2.sh"
                ],
                "delta": "0:00:00.003282",
                "end": "2023-06-22 11:29:26.807814",
                "failed": false,
                "invocation": {
                    "module_args": {
                        "_raw_params": "cat \"/home/vagrant/workdir/codes/script2.sh\"",
                        "_uses_shell": false,
                        "argv": null,
                        "chdir": null,
                        "creates": null,
                        "executable": null,
                        "removes": null,
                        "stdin": null,
                        "warn": true
                    }
                },
                "item": "/home/vagrant/workdir/codes/script2.sh",
                "rc": 0,
                "start": "2023-06-22 11:29:26.804532",
                "stderr": "",
                "stderr_lines": [],
                "stdout": "#!/bin/bash\n\necho -n \"Let's play a game: Pick a number between 0 and 32767: \"\nread a\nif (( RANDOM == a )); then\n   echo AMAZING, your answer is correct\nelse\n   echo Sorry, that was wrong\nfi",
                "stdout_lines": [
                    "#!/bin/bash",
                    "",
                    "echo -n \"Let's play a game: Pick a number between 0 and 32767: \"",
                    "read a",
                    "if (( RANDOM == a )); then",
                    "   echo AMAZING, your answer is correct",
                    "else",
                    "   echo Sorry, that was wrong",
                    "fi"
                ]
            }
        ]
    }
}

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
10.22.97.60                : ok=13   changed=2    unreachable=0    failed=0

root@vita1:/home/vagrant/vita_proj#
```

![vita2](img/p1.JPG)

### Комментарии  

- Что я могу сказать. Т.к. структуру папок до этого ансиблом я не раскидывал - гуглить пришлось много. Модуль copy, оказывается не знает параметр recusrsive и я долго разбирался, чем заменить. В итоге, заменил на synchronize. Далее, я захотел добавить красоты и вывести все, что создалось и содержимое файлов в терминал, но до конца победить не смог и у меня лезет огромная простыня из которой, в принципе, можно вычленить нужное, но не так легко, как это хотел видеть я. Пробовал дописывать в var вот в таком виде - *result.stdout_lines*, что кажется логичным, но так не выходит.

- Относительно различий между *loop* и *with_items*. Если честно, я для себя их особо не нашел. Да, пишут, что *with_items* сейчас уже не используют почти и в сравнении с *loop* там чуть другой синтаксис, но я попробовал и то и другое и разницы для себя (пока) не увидел совсем. Использовал loop.  

- Относительно того, что "запустил и не работает". Запустил что? Плэйбук. Там можно понять на каком шаге и уже смотреть подробнее. Также, если я не ошибаюсь, можно использовать *-vvv* для более подробного отображения выполнения плэйбука. Ну и синтаксис yaml-файла можно тоже проверить через --syntax-check. 





### Теперь попробуем навернуть доккера, закинуть в yaml-манифест все, что нужно по заданию и раскатать. Уффф...



  
 





