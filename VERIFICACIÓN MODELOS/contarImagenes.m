function total = contarImagenes(tabla_rutas, extension)
    total = 0;
    for i = 1:height(tabla_rutas)
        ruta = tabla_rutas.RutaImagenes{i};
        archivos = dir(fullfile(ruta, ['*' extension]));
        total = total + numel(archivos);
    end
end