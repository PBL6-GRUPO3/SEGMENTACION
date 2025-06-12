function tabla_resultados=evaluar_ruido_Uninfected(Total_ruido, Total_imagenes,Metodo,nombre_tabla)

    Media=Total_ruido/Total_imagenes;
    Metodo = string(Metodo);
  
    fprintf('Ruido total de %s: %d\n',Metodo, Total_ruido);

    fprintf('Media de ruido de %s: %.2f\n',Metodo, Media);

    % Crear tabla con resultados
    tabla_resultados = table(Metodo, Total_ruido, Media,Total_imagenes);

    % Guardar la tabla como archivo CSV
    writetable(tabla_resultados, nombre_tabla);
end