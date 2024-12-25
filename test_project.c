#include <quantum.h>
#include <stdio.h>
#include <math.h>

// Вывод состояния регистра
void print_register(quantum_reg reg) {
    printf("Текущее состояние регистра:\n");
    for (int i = 0; i < reg.size; i++) {
        printf("  Состояние: %llu, Вероятность: %f\n",
               reg.state[i], quantum_prob(reg.amplitude[i]));
    }
}

int main() {
    // Создаём квантовый регистр с 2 кубитами
    quantum_reg reg = quantum_new_qureg(0, 2);
    printf("Начальное состояние регистра создано.\n");
    print_register(reg);

    // Применяем операцию Адамара к первому кубиту
    quantum_hadamard(0, &reg);
    printf("Операция Адамара применена к кубиту 0.\n");
    print_register(reg);

    // Применяем CNOT к кубитам 0 и 1
    quantum_cnot(0, 1, &reg);
    printf("Операция CNOT между кубитами 0 и 1 выполнена.\n");
    print_register(reg);

    // Измеряем вероятность каждого состояния
    for (int i = 0; i < reg.size; i++) {
        printf("Состояние: %llu, Вероятность: %f\n", reg.state[i], quantum_prob(reg.amplitude[i]));
    }

    // Проверяем корректность вероятностей
    double prob_00 = quantum_prob(reg.amplitude[0]); // |00>
    double prob_11 = quantum_prob(reg.amplitude[1]); // |11>, вероятно, не 3

    printf("Вероятность |00>: %f\n", prob_00);
    printf("Вероятность |11>: %f\n", prob_11);

    if (fabs(prob_00 - 0.5) < 0.001 && fabs(prob_11 - 0.5) < 0.001) {
        printf("Тест пройден: вероятности правильные.\n");
    } else {
        printf("Ошибка: вероятности не совпадают с ожидаемыми значениями.\n");
    }

    // Измеряем регистр
    int result = quantum_measure(reg);
    printf("Измерение завершено. Результат: %d\n", result);

    // Освобождаем память
    quantum_delete_qureg(&reg);
    printf("Квантовый регистр очищен.\n");

    return 0;
}
