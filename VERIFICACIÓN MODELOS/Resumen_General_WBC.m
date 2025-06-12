function Resumen_General_WBC(T_Resumen_Uninfected, T_Resumen_PF_WBC)

    % Obtener nombres de métodos desde una de las tablas
    metodos = T_Resumen_Uninfected.metodo;
    
    % Sumar TP, FP y FN de las 4 tablas
    TP_total = T_Resumen_Uninfected.TP + T_Resumen_PF_WBC.TP;
    
    FP_total = T_Resumen_Uninfected.FP + T_Resumen_PF_WBC.FP;
    
    FN_total = T_Resumen_Uninfected.FN + T_Resumen_PF_WBC.FN;
    
    % Crear nueva tabla con los resultados sumados
    T_General = table(metodos, TP_total, FP_total, FN_total, ...
                      'VariableNames', {'metodo', 'TP', 'FP', 'FN'});
    
    Precision = (T_General.TP ./ (T_General.TP + T_General.FP)) * 100;
    Sensibilidad = (T_General.TP ./ (T_General.TP + T_General.FN)) * 100;
    
    % Añadir columnas a la tabla general
    T_General.Precision = Precision;
    T_General.Sensibilidad = Sensibilidad;
    
    fprintf('\n===== RESUMEN DE RESULTADOS WBC =====\n\n');
    % Mostrar la tabla
    disp(T_General);
    
    % Guardar como .csv
    writetable(T_General, 'Resumen_General_WBC.csv');
end