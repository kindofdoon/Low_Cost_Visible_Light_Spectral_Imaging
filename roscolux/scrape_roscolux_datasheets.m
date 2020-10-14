% function scrape_roscolux_datasheets

    clear
    clc
    
    %%
    
    % 'https://www.pnta.com/expendables/gels/roscolux/roscolux-07-pale-yellow/'
    URL_template = 'https://www.pnta.com/expendables/gels/roscolux/roscolux-ID-DESC/';
    
    % Source: https://us.rosco.com/sites/default/files/content/resource/2016-09/rosco_roscolux.pdf
    R = {
            'R00',   'Clear'
            'R01',   'Light Bastard Amber'
            'R02',   'Bastard Amber'
            'R03',   'Dark Bastard Amber'
            'R04',   'Medium Bastard Amber'
            'R304',  'Pale Apricot'
            'R05',   'Rose Tint'
            'R305',  'Rose Gold'
            'R06',   'No Color Straw'
            'R07',   'Pale Yellow'
            'R08',   'Pale Gold'
            'R09',   'Pale Amber Gold'
            'R4515', 'CC15 Yellow'
            'R4530', 'CC30 Yellow'
            'R4560', 'CC60 Yellow'
            'R4590', 'CC90 Yellow'
            'R10',   'Medium Yellow'
            'R310',  'Daffodil'
            'R11',   'Light Straw'
            'R12',   'Straw'
            'R312',  'Canary'
            'R2003', 'Storaro Yellow'
            'R13',   'Straw Tint'
            'R14',   'Medium Straw'
            'R15',   'Deep Straw'
            'R16',   'Light Amber'
            'R316',  'Gallo Gold'
            'R17',   'Light Flame'
            'R317',  'Apricot'
            'R18',   'Flame'
            'R318',  'Mayan Sun'
            'R19',   'Fire'
            'R20',   'Medium Amber'
            'R21',   'Golden Amber'
            'R321',  'Soft Golden Amber'
            'R2002', 'Storaro Orange'
            'R22',   'Deep Amber'
            'R23',   'Orange'
            'R4615', 'CC15 Red'
            'R4630', 'CC30 Red'
            'R4660', 'CC60 Red'
            'R4690', 'CC90 Red'
            'R24',   'Scarlet'
            'R25',   'Orange Red'
            'R26',   'Light Red'
            'R27',   'Medium Red'
            'R30',   'Light Salmon Pink'
            'R31',   'Salmon Pink'
            'R32',   'Medium Salmon Pink'
            'R332',  'Cherry Rose'
            'R33',   'No Color Pink'
            'R333',  'Blush Pink'
            'R34',   'Flesh Pink'
            'R35',   'Light Pink'
            'R36',   'Medium Pink'
            'R4815', 'CC15 Pink'
            'R4830', 'CC30 Pink'
            'R4860', 'CC60 Pink'
            'R4890', 'CC90 Pink'
            'R336',  'Billington Pink'
            'R37',   'Pale Rose Pink'
            'R337',  'True Pink'
            'R4715', 'CC15 Magenta'
            'R4730', 'CC30 Magenta'
            'R4760', 'CC60 Magenta'
            'R4790', 'CC90 Magenta'
            'R38',   'Light Rose'
            'R39',   'Skelton Exotic Sangria'
            'R339',  'Broadway Pink'
            'R40',   'Light Salmon'
            'R41',   'Salmon'
            'R42',   'Deep Salmon'
            'R342',  'Rose Pink'
            'R43',   'Deep Pink'
            'R343',  'Neon Pink'
            'R44',   'Middle Rose'
            'R344',  'Follies Pink'
            'R45',   'Rose'
            'R46',   'Magenta'
            'R346',  'Tropical Magenta'
            'R47',   'Light Rose Purple'
            'R48',   'Rose Purple'
            'R49',   'Medium Purple'
            'R349',  'Fisher Fuchsia'
            'R50',   'Mauve'
            'R51',   'Surprise Pink'
            'R52',   'Light Lavender'
            'R53',   'Pale Lavender'
            'R54',   'Special Lavender'
            'R4915', 'CC15 Lavender'
            'R4930', 'CC30 Lavender'
            'R4960', 'CC60 Lavender'
            'R4990', 'CC90 Lavender'
            'R55',   'Lilac'
            'R355',  'Pale Violet'
            'R56',   'Gypsy Lavender'
            'R356',  'Middle Lavender'
            'R57',   'Lavender'
            'R357',  'Royal Lavender'
            'R58',   'Deep Lavender'
            'R358',  'Rose Indigo'
            'R2009', 'Storaro Violet'
            'R2008', 'Storaro Indigo'
            'R59',   'Indigo'
            'R359',  'Medium Violet'
            'R4215', 'CC15 Blue'
            'R4230', 'CC30 Blue'
            'R4260', 'CC60 Blue'
            'R4290', 'CC90 Blue'
            'R60',   'No Color Blue'
            'R360',  'Clearwater'
            'R61',   'Mist Blue'
            'R62',   'Booster Blue'
            'R362',  'Tipton Blue'
            'R63',   'Pale Blue'
            'R363',  'Aquamarine'
            'R64',   'Light Steel Blue'
            'R364',  'Blue Bell'
            'R65',   'Daylight Blue'
            'R365',  'Tharon Delft Blue'
            'R66',   'Cool Blue'
            'R67',   'Light Sky Blue'
            'R367',  'Slate Blue'
            'R68',   'Sky Blue'
            'R69',   'Brilliant Blue'
            'R70',   'Nile Blue'
            'R370',  'Italian Blue'
            'R71',   'Sea Blue'
            'R72',   'Azure Blue'
            'R4315', 'CC15 Cyan'
            'R4330', 'CC30 Cyan'
            'R4360', 'CC60 Cyan'
            'R4390', 'CC90 Cyan'
            'R73',   'Peacock Blue'
            'R74',   'Night Blue'
            'R76',   'Light Green Blue'
            'R376',  'Bermuda Blue'
            'R77',   'Green Blue'
            'R78',   'Trudy Blue'
            'R378',  'Alice Blue'
            'R2007', 'Storaro Blue'
            'R79',   'Bright Blue'
            'R80',   'Primary Blue'
            'R81',   'Urban Blue'
            'R82',   'Surprise Blue'
            'R382',  'Congo Blue'
            'R83',   'Medium Blue'
            'R383',  'Sapphire Blue'
            'R84',   'Zephyr Blue'
            'R85',   'Deep Blue'
            'R385',  'Royal Blue'
            'R86',   'Pea Green'
            'R87',   'Pale Yellow Green'
            'R4415', 'CC15 Green'
            'R4430', 'CC30 Green'
            'R4460', 'CC60 Green'
            'R4490', 'CC90 Green'
            'R88',   'Light Green'
            'R388',  'Gaslight Green'
            'R89',   'Moss Green'
            'R389',  'Chroma Green'
            'R2004', 'Storaro Green'
            'R90',   'Dark Yellow Green'
            'R91',   'Primary Green'
            'R92',   'Turquoise'
            'R93',   'Blue Green'
            'R94',   'Kelly Green'
            'R95',   'Medium Blue Green'
            'R395',  'Teal Green'
            'R96',   'Lime'
            'R97',   'Light Grey'
            'R397',  'Pale Grey'
            'R98',   'Medium Grey'
            'R99',   'Chocolate'
        };
    
    %%
    
    f_qty = size(R,1);
    
    ID   = cell(f_qty,1);
    desc = cell(f_qty,1);
    
    for f = 1 : f_qty
        
        ID{f}   = R{f,1}(2:end);
        desc{f} = regexprep(lower(R{f,2}), ' ', '-');
        
    end
    
    %%
    
    for f = 1 : f_qty
        
        URL = URL_template;
        URL = regexprep(URL, 'ID',   ID{f});
        URL = regexprep(URL, 'DESC', desc{f});
    
        tag = [ID{f} '_' desc{f}];
        disp(tag)
        clipboard('copy', tag)
        
        try
            html = webread(URL);
        catch ME
            warning('webread error')
            continue
        end
        
        % data-zoom-image="https://cdn11.bigcommerce.com/s-nnyoihm3uz/images/stencil/1280x1280/products/7955/9305/R01__19243__22846.1522033550.jpg?c=2"
        alnud = '[a-zA-Z0-9-_]+'; % alphabet, numbers, dash, underscore
        re_im_search = ['(https://' alnud '\.bigcommerce\.com/' alnud '/images/stencil/1280x1280/products/' alnud '/' alnud '/' '.{10,100}' '\.jpg)'];
        
        tok = regexp(html, re_im_search, 'tokens');
        if length(tok) >= 1
            tok = tok{1}{1};
            I = imread(tok);
            fn_export = ['roscolux_' tag '.jpg'];
            imwrite(I, fn_export)
            disp(['  Saved ' fn_export])
        else
            continue % didn't find the image
            warning('regexp error')
        end
        
%         pause
        
    end
    
    

% end




































