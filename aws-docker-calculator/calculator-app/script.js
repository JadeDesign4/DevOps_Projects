let displayValue = '0';
const display = document.getElementById('display');

function updateDisplay() {
    display.innerText = displayValue;
}

function append(value) {
    // If the display is '0' and we aren't adding a decimal, replace the '0'
    if (displayValue === '0' && value !== '.') {
        displayValue = value;
    } else {
        displayValue += value;
    }
    updateDisplay();
}

function setOperator(op) {
    const lastChar = displayValue.slice(-1);
    const operators = ['+', '-', '*', '/'];

    // Prevent double operators by replacing the last one if clicked again
    if (operators.includes(lastChar)) {
        displayValue = displayValue.slice(0, -1) + op;
    } else {
        displayValue += op;
    }
    updateDisplay();
}

function calculate() {
    try {
        // eval() is used here for simplicity in a vanilla JS project
        // to process the full string as a math expression
        const result = eval(displayValue);
        displayValue = result.toString();
        updateDisplay();
    } catch (e) {
        displayValue = 'Error';
        updateDisplay();
        setTimeout(clearDisplay, 1500);
    }
}

function clearDisplay() {
    displayValue = '0';
    updateDisplay();
}
