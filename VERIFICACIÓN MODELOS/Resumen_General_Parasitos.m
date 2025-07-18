function Resumen_General_Parasitos(T_Resumen_PF_Parasitos,T_Resumen_PV)

    % Obtener nombres de métodos desde una de las tablas
    metodos = T_Resumen_PF_Parasitos.metodo;
    
    % Sumar TP, FP y FN de las 4 tablas
    TP_total = T_Resumen_PF_Parasitos.TP + T_Resumen_PV.TP;
    
    FP_total = T_Resumen_PF_Parasitos.FP + T_Resumen_PV.FP;
    
    FN_total = T_Resumen_PF_Parasitos.FN + T_Resumen_PV.FN;
    
    % Crear nueva tabla con los resultados sumados
    T_General = table(metodos, TP_total, FP_total, FN_total, ...
                      'VariableNames', {'metodo', 'TP', 'FP', 'FN'});
    
    Precision = (T_General.TP ./ (T_General.TP + T_General.FP)) * 100;
    Sensibilidad = (T_General.TP ./ (T_General.TP + T_General.FN)) * 100;
    
    % Añadir columnas a la tabla general
    T_General.Precision = Precision;
    T_General.Sensibilidad = Sensibilidad;
    
    fprintf('\n===== RESUMEN DE RESULTADOS Parasitos =====\n\n');
    % Mostrar la tabla
    disp(T_General);
    
    % Guardar como .csv
    writetable(T_General, 'Resumen_General_Parasitos.csv');
end