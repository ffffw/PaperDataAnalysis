function data = MyNormlize(data, normScale, delta) 
    
    data = normScale * data / max(data);
    data = round(data);
       
    data = floor(data ./ pow2(delta));    

end

