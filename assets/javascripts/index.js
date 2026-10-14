/***
 * Don't delete below code!!! It is working for [auto form field](username and password). 
 */

// window.flutter_inappwebview.callHandler('link_redirector', 'feature://permission?for=location')

function AllowZoom(flag) {
    if (flag) {
        document.querySelector("head meta[name=viewport]").remove();
        document.querySelector("head").prepend('<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=10.0, minimum-scale=1, user-scalable=1" />');
    } else {
        document.querySelector("head meta[name=viewport]").remove();
        document.querySelector("head").prepend('<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=0" />');
    }
}

function addDeleteMyAccount(parentSelector) {
    if (!parentSelector || parentSelector === ``) return;
    function addDeleteMyAccountButton() {
        var parentElement = document.querySelector(parentSelector);
        var deleteMyButton = document.createElement("button");
        deleteMyButton.innerText = "Delete My Account";
        deleteMyButton.id = "deleteMyAccount";
        deleteMyButton.style.marginTop = "10px";
        deleteMyButton.style.marginBottom = "10px";
        deleteMyButton.style.width = "100%";
        deleteMyButton.style.background = "red";
        deleteMyButton.style.fontSize = "18px";
        deleteMyButton.style.color = "white";
        deleteMyButton.onclick = (e) => {
            e.preventDefault();
            confirm("Do you want to delete the account with all the stored data? It will be deleted if you confirm this dialog. ")
        };
        if (!document.getElementById('deleteMyAccount')) {
            parentElement.appendChild(deleteMyButton);
        }
    }
    setInterval(addDeleteMyAccountButton, 1000);
    addDeleteMyAccountButton();
}

try {
    function changeInputValue(input, value) {

        var nativeInputValueSetter = Object.getOwnPropertyDescriptor(
            window.HTMLInputElement.prototype,
            "value"
        ).set;
        nativeInputValueSetter.call(input, value);

        var inputEvent = new Event("input", { bubbles: true });
        input.dispatchEvent(inputEvent);
    }
} catch (e) {
}

try {
    document.querySelector(doom_username).addEventListener("keyup", (e) => {
        window.flutter_inappwebview.callHandler("Username", e.target.value);
    });

    if (username) {
        changeInputValue(document.querySelector(doom_username), username);
    }

} catch (e) {
}

try {
    document.querySelector(doom_password).addEventListener("keyup", (e) => {
        window.flutter_inappwebview.callHandler("Password", e.target.value);
    });

    if (password) {
        changeInputValue(document.querySelector(doom_password), password);
    }
} catch (e) {
}

function addRegisterButton(loginFormQuery, loginButtonQuery) {
    try {
        const loginForm = document.querySelector(loginFormQuery);
        const loginButton = document.querySelector(loginButtonQuery);

        // Yeni butonu oluştur
        const registerButton = document.createElement("button");
        registerButton.value = "Register";
        registerButton.innerText = "Register";
        registerButton.id = "register_button";
        registerButton.className = loginButton.className;

        registerButton.setAttribute("type", "button");
        if (!document.querySelector("#register_button")) {
            loginForm.appendChild(document.createElement("br"));
            loginForm.appendChild(registerButton);
        }

        // Modal HTML'ini oluştur
        const modalHtml = `
      <div id="customModal" class="custom-modal">
        <div class="custom-modal-content">
          <span class="custom-close">&times;</span>
          <h3>Register Form</h3>
          <form>
            <label>Email:</label>
            <input type="text" id="email" class="custom-input"><br>
            <label>Password:</label>
            <input type="password" id="password" class="custom-input"><br>
            <label>Re-password:</label>
            <input type="password" id="repassword" class="custom-input"><br>
            <button type="button" class="custom-button" id="registerConfirmBtn">Register</button>
          </form>
        </div>
      </div>
    `;

        // CSS'yi ekle
        const modalStyles = `
      .custom-modal {
        display: none;
        position: fixed;
        z-index: 99999999;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgba(0,0,0,0.4);
      }

      .custom-modal-content {
        background-color: #fff;
        margin: 10% auto;
        padding: 20px;
        border: 1px solid #888;
        width: 300px;
        border-radius: 8px;
        position: relative;
      }

      .custom-close {
        position: absolute;
        top: 10px;
        right: 15px;
        color: #aaa;
        font-size: 28px;
        font-weight: bold;
        cursor: pointer;
      }

      .custom-close:hover {
        color: black;
      }

      .custom-input {
        width: 100%;
        padding: 8px;
        margin: 6px 0;
        box-sizing: border-box;
      }

      .custom-button {
        background-color: #007bff;
        color: white;
        padding: 10px;
        width: 100%;
        border: none;
        border-radius: 4px;
        cursor: pointer;
      }

      .custom-button:hover {
        background-color: #0056b3;
      }
    `;

        if (!document.querySelector("#customModal")) {
            const modalWrapper = document.createElement("div");
            modalWrapper.innerHTML = modalHtml;
            document.body.appendChild(modalWrapper.firstElementChild);

            const styleEl = document.createElement("style");
            styleEl.textContent = modalStyles;
            document.head.appendChild(styleEl);
        }

        // Butona tıklayınca modalı göster
        registerButton.addEventListener("click", function () {
            document.getElementById("customModal").style.display = "block";
        });

        // Modalı kapatma
        document.addEventListener("click", function (e) {
            const modal = document.getElementById("customModal");
            if (e.target.classList.contains("custom-close") || e.target === modal) {
                modal.style.display = "none";
            }
        });

        // Register işlemi (örnek alert)
        document.addEventListener("click", function (e) {
            if (e.target && e.target.id === "registerConfirmBtn") {
                alert("Verification email has been sent. Please verify the account, then login!");
                document.getElementById("customModal").style.display = "none";
            }
        });
    } catch { }
}



