is_error = 0

# Sprawdzanie poprawnosci danych 

try
    input_string = input('Wprowadz punkty w formacie x0,y0;x1,y1;...;xn,yn: ','s');
    split_input = strsplit(input_string,";")
    len = length(split_input)
    
    w = [] # tablica wezlow
    v = [] #tablica wartosci

    for i = 1:len
        split_inp = split_input{i}
        split_input2 = strsplit(split_inp,",")
        
        if length(split_input2)!= 2
           is_error = 1
        endif
        
        if is_error == 0
            if !isnumeric(str2num((split_input2{1}))) || !isnumeric(str2num(split_input2{2}))
                is_error = 1  
            endif
        endif
        
        if is_error == 0
           w(i) = str2num(split_input2{1})
           v(i) = str2num(split_input2{2})
        endif
    endfor
catch
    is_error = 1
end_try_catch

if is_error == 1
    printf("Wprowadzono niepoprawne dane\n")  
endif

if is_error == 0

    # sortowanie wezlow rosnaco

    for i = 1:length(w)
        for j = 1:length(w) - 1
            if w(j) > w(j + 1)
                pom = w(j)
                w(j) = w(j + 1)
                w(j + 1) = pom
                pom = v(j)
                v(j) = v(j + 1)
                v(j + 1) = pom
            endif
        endfor
    endfor


    # Sprawdzanie czy istnieja wezly wielokrotne

    multiple = 0

    for i = 2:length(v)
        if w(i - 1) == w(i)
            multiple = 1
            break
        endif
    endfor

    if multiple == 1
        v2 = v
        uniq = unique(w)
        for i = 1:length(uniq)
            ind = find(w == uniq(i))
            val = v(ind(1))
            for j = 1:length(ind)
                v(ind(j)) = val
            endfor
        endfor
    endif

    for i = 1:length(v)
        for j = length(v):-1:(i + 1)
            if w(j) != w(j-i)
                v(j) = (v(j) - v(j - 1)) / (w(j) - w(j - i))
            else
                ind = find(w == w(j))
                val = v2(ind(i + 1))
                v(j) = val / factorial(i)
            endif
        endfor
    endfor

    
    # Wyznaczanie wzoru wielomianu
    form = zeros(length(v),length(v))

    for i = 1:length(v)
        for j = 1:length(v)
            if i == j
                form(i,j) = 1
            elseif(i == 2 && j == 1)
                form(i,j) = -1*w(i-1)
            elseif i==3 || i>3
                if j == 1
                     form(i,j) = form(i - 1,1)* - 1*w(i - 1)
                endif
                if j == 2
                    form(i,j) = form(i - 1,1) + form(i - 1,2)* - 1*w(i - 1)
                endif
            endif
      
            if (i == 4 || i>4) && j<i
                if j == length(v)-1 && i != j
                    form(i,j) = form(i - 1,j - 1)+(-1)*w(i - 1)  
                elseif j != length(v) - 1 && j != 1 && j != 2 && i!=j && j!= length(v)
                    form(i,j) = form(i - 1,j - 1)+form(i - 1,j)*(-1)*w(i -1 ) 
                endif
            endif
        endfor
    endfor
 
    for i = 1:length(v)
        for j = 1:length(v)
           form(i,j ) = form(i,j)*v(i)
        endfor
    endfor
 
    printf("Wzor wielomianu:\n")
 
    for i = 1:length(v)
        if sum(form(:,i))>0 && i>1
           printf("+")
        endif
        if i == 1
            printf ("%d ",sum(form(:,i)))
        elseif i>1 && sum(form(:,i)) !=0
            printf("%d",sum(form(:,i)))
        endif
        if i==2 && abs(sum(form(:,i))) !=0
            printf("x ")
        endif
        if (i==3 || i>3) && abs(sum(form(:,i))) !=0
            printf("x^%d ",i-1)
        endif
    endfor
endif

