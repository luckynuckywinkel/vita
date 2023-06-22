### Тестовое задание на позицию junior dev/ops engineer, Лебедев А. И.    

  


- Я решил объединить задания 1 и 3 в один стэк и попробовать выполнить все используя используя Ansible.
  Машины разверну в virtual box используя vagrant. Можно было бы сделать все это в yzndex cloud и через Terraform, но, считаю, что пока это весьма тернистый путь и давайте исходить из текущих задач.

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

- Запишем адрес необходоимой машины в inventory, создадим и прокинем ssh-ключ (ssh-copy-id -i vkey.pub userid@ip) и попробуем проверить соединение. И вот, о чем я и говорил:

![false](img/false.JPG)  

Я вижу, что на второй машине есть python, но ансибловый пинг валится в ошибку. Я сталкивался с этим и на яндекс клауде и так и не понял в чем дело. Но, ансибл имеет такой модуль - raw. Собственно, как я понял, им, в основном, такую проблему и решают. Допишем одну строчку в inventory и сделаем #raw_playbook.yaml.  
  
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
                "delta": "0:00:00.004061",
                "end": "2023-06-22 11:11:42.871792",
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
                "start": "2023-06-22 11:11:42.867731",
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
                "delta": "0:00:00.003712",
                "end": "2023-06-22 11:11:43.230083",
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
                "start": "2023-06-22 11:11:43.226371",
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
                "delta": "0:00:00.004163",
                "end": "2023-06-22 11:11:43.588699",
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
                "start": "2023-06-22 11:11:43.584536",
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
                "delta": "0:00:00.003878",
                "end": "2023-06-22 11:11:43.927786",
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
                "start": "2023-06-22 11:11:43.923908",
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
failed: [10.22.97.60] (item=/home/vagrant/workdir/codes/script.sh) => {"changed": true, "cmd": ["cat", "/home/vagrant/workdir/codes/script.sh"], "delta": "0:00:00.003303", "end": "2023-06-22 11:11:44.468166", "item": "/home/vagrant/workdir/codes/script.sh", "msg": "non-zero return code", "rc": 1, "start": "2023-06-22 11:11:44.464863", "stderr": "cat: /home/vagrant/workdir/codes/script.sh: No such file or directory", "stderr_lines": ["cat: /home/vagrant/workdir/codes/script.sh: No such file or directory"], "stdout": "", "stdout_lines": []}
changed: [10.22.97.60] => (item=/home/vagrant/workdir/codes/script2.sh)
...ignoring

TASK [vita_copy : Out_code] *****************************************************************************************************************************************************************************************************************
ok: [10.22.97.60] => {
    "msg": "####Содержимое файлов со скриптами####"
}

TASK [vita_copy : Out_code_result] **********************************************************************************************************************************************************************************************************
ok: [10.22.97.60] => {
    "resultcode": {
        "changed": true,
        "failed": true,
        "msg": "All items completed",
        "results": [
            {
                "_ansible_item_label": "/home/vagrant/workdir/codes/script.sh",
                "_ansible_item_result": true,
                "_ansible_no_log": false,
                "_ansible_parsed": true,
                "changed": true,
                "cmd": [
                    "cat",
                    "/home/vagrant/workdir/codes/script.sh"
                ],
                "delta": "0:00:00.003303",
                "end": "2023-06-22 11:11:44.468166",
                "failed": true,
                "invocation": {
                    "module_args": {
                        "_raw_params": "cat \"/home/vagrant/workdir/codes/script.sh\"",
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
                "item": "/home/vagrant/workdir/codes/script.sh",
                "msg": "non-zero return code",
                "rc": 1,
                "start": "2023-06-22 11:11:44.464863",
                "stderr": "cat: /home/vagrant/workdir/codes/script.sh: No such file or directory",
                "stderr_lines": [
                    "cat: /home/vagrant/workdir/codes/script.sh: No such file or directory"
                ],
                "stdout": "",
                "stdout_lines": []
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
                "delta": "0:00:00.004973",
                "end": "2023-06-22 11:11:44.815882",
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
                "start": "2023-06-22 11:11:44.810909",
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




  
 





