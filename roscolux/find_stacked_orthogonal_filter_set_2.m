% function find_stacked_orthogonal_filter_set_2

    % This version, _2, is more general, and can consider filter stacks
    % between 1 and 3 filters thick.

    %%
    
    clear
    clc
    
    %% Inputs
    
    lam_lims = [400, 700]; % lambda limits
    f_qty = 13; % number of filters/wavelength stations
    use_max = 2; % maximum number of times that a filter can be used to building the set (i.e. the physical material limit)
    
    % Define range of acceptable total overall transmission
%     t_lims = [0.40 0.50]; % 1 ISO increment,  2x
    t_lims = [0.15 0.25]; % 2 ISO increments, 4x
    
    GIF_fn = 'orthogonal_stacked_set.GIF';
    GIF_fps = 1;
    
    % List of filters to omit, e.g. due to mismatched data, material damage, etc.
    omit_list = {
                    '3405'
                    '19_fire'
                    '25_orange-red'
                    '42_deep-salmon'
                };
    
    %% Load external data
    
    Filters = load_roscolux_filters(0);
    
    % Omit filters as requested
    for o = 1 : length(omit_list)
        for f = 1 : Filters.qty
            if ~isempty(strfind(Filters.name{f}, omit_list{o}))
                disp(['Omitting ' Filters.name{f}])
                Filters.name(f) = [];
                Filters.T(f,:) = [];
                Filters.qty = Filters.qty - 1;
                Filters.booklet_index(f) = [];
                Filters.XYZ(f,:) = [];
                Filters.RGB(f,:) = [];
                break
            end
        end
    end
    
    %% Constants
    
    % D65 for RGB
    Illuminant.lambda = [300 301 302 303 304 305 306 307 308 309 310 311 312 313 314 315 316 317 318 319 320 321 322 323 324 325 326 327 328 329 330 331 332 333 334 335 336 337 338 339 340 341 342 343 344 345 346 347 348 349 350 351 352 353 354 355 356 357 358 359 360 361 362 363 364 365 366 367 368 369 370 371 372 373 374 375 376 377 378 379 380 381 382 383 384 385 386 387 388 389 390 391 392 393 394 395 396 397 398 399 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 419 420 421 422 423 424 425 426 427 428 429 430 431 432 433 434 435 436 437 438 439 440 441 442 443 444 445 446 447 448 449 450 451 452 453 454 455 456 457 458 459 460 461 462 463 464 465 466 467 468 469 470 471 472 473 474 475 476 477 478 479 480 481 482 483 484 485 486 487 488 489 490 491 492 493 494 495 496 497 498 499 500 501 502 503 504 505 506 507 508 509 510 511 512 513 514 515 516 517 518 519 520 521 522 523 524 525 526 527 528 529 530 531 532 533 534 535 536 537 538 539 540 541 542 543 544 545 546 547 548 549 550 551 552 553 554 555 556 557 558 559 560 561 562 563 564 565 566 567 568 569 570 571 572 573 574 575 576 577 578 579 580 581 582 583 584 585 586 587 588 589 590 591 592 593 594 595 596 597 598 599 600 601 602 603 604 605 606 607 608 609 610 611 612 613 614 615 616 617 618 619 620 621 622 623 624 625 626 627 628 629 630 631 632 633 634 635 636 637 638 639 640 641 642 643 644 645 646 647 648 649 650 651 652 653 654 655 656 657 658 659 660 661 662 663 664 665 666 667 668 669 670 671 672 673 674 675 676 677 678 679 680 681 682 683 684 685 686 687 688 689 690 691 692 693 694 695 696 697 698 699 700 701 702 703 704 705 706 707 708 709 710 711 712 713 714 715 716 717 718 719 720 721 722 723 724 725 726 727 728 729 730 731 732 733 734 735 736 737 738 739 740 741 742 743 744 745 746 747 748 749 750 751 752 753 754 755 756 757 758 759 760 761 762 763 764 765 766 767 768 769 770 771 772 773 774 775 776 777 778 779 780 781 782 783 784 785 786 787 788 789 790 791 792 793 794 795 796 797 798 799 800 801 802 803 804 805 806 807 808 809 810 811 812 813 814 815 816 817 818 819 820 821 822 823 824 825 826 827 828 829 830];
    Illuminant.power  = [0.0341 0.36014 0.68618 1.01222 1.33826 1.6643 1.99034 2.31638 2.64242 2.96846 3.2945 4.98865 6.6828 8.37695 10.0711 11.7652 13.4594 15.1535 16.8477 18.5418 20.236 21.9177 23.5995 25.2812 26.963 28.6447 30.3265 32.0082 33.69 35.3717 37.0535 37.343 37.6326 37.9221 38.2116 38.5011 38.7907 39.0802 39.3697 39.6593 39.9488 40.4451 40.9414 41.4377 41.934 42.4302 42.9265 43.4228 43.9191 44.4154 44.9117 45.0844 45.257 45.4297 45.6023 45.775 45.9477 46.1203 46.293 46.4656 46.6383 47.1834 47.7285 48.2735 48.8186 49.3637 49.9088 50.4539 50.9989 51.544 52.0891 51.8777 51.6664 51.455 51.2437 51.0323 50.8209 50.6096 50.3982 50.1869 49.9755 50.4428 50.91 51.3773 51.8446 52.3118 52.7791 53.2464 53.7137 54.1809 54.6482 57.4589 60.2695 63.0802 65.8909 68.7015 71.5122 74.3229 77.1336 79.9442 82.7549 83.628 84.5011 85.3742 86.2473 87.1204 87.9936 88.8667 89.7398 90.6129 91.486 91.6806 91.8752 92.0697 92.2643 92.4589 92.6535 92.8481 93.0426 93.2372 93.4318 92.7568 92.0819 91.4069 90.732 90.057 89.3821 88.7071 88.0322 87.3572 86.6823 88.5006 90.3188 92.1371 93.9554 95.7736 97.5919 99.4102 101.228 103.047 104.865 106.079 107.294 108.508 109.722 110.936 112.151 113.365 114.579 115.794 117.008 117.088 117.169 117.249 117.33 117.41 117.49 117.571 117.651 117.732 117.812 117.517 117.222 116.927 116.632 116.336 116.041 115.746 115.451 115.156 114.861 114.967 115.073 115.18 115.286 115.392 115.498 115.604 115.711 115.817 115.923 115.212 114.501 113.789 113.078 112.367 111.656 110.945 110.233 109.522 108.811 108.865 108.92 108.974 109.028 109.082 109.137 109.191 109.245 109.3 109.354 109.199 109.044 108.888 108.733 108.578 108.423 108.268 108.112 107.957 107.802 107.501 107.2 106.898 106.597 106.296 105.995 105.694 105.392 105.091 104.79 105.08 105.37 105.66 105.95 106.239 106.529 106.819 107.109 107.399 107.689 107.361 107.032 106.704 106.375 106.047 105.719 105.39 105.062 104.733 104.405 104.369 104.333 104.297 104.261 104.225 104.19 104.154 104.118 104.082 104.046 103.641 103.237 102.832 102.428 102.023 101.618 101.214 100.809 100.405 100 99.6334 99.2668 98.9003 98.5337 98.1671 97.8005 97.4339 97.0674 96.7008 96.3342 96.2796 96.225 96.1703 96.1157 96.0611 96.0065 95.9519 95.8972 95.8426 95.788 95.0778 94.3675 93.6573 92.947 92.2368 91.5266 90.8163 90.1061 89.3958 88.6856 88.8177 88.9497 89.0818 89.2138 89.3459 89.478 89.61 89.7421 89.8741 90.0062 89.9655 89.9248 89.8841 89.8434 89.8026 89.7619 89.7212 89.6805 89.6398 89.5991 89.4091 89.219 89.029 88.8389 88.6489 88.4589 88.2688 88.0788 87.8887 87.6987 87.2577 86.8167 86.3757 85.9347 85.4936 85.0526 84.6116 84.1706 83.7296 83.2886 83.3297 83.3707 83.4118 83.4528 83.4939 83.535 83.576 83.6171 83.6581 83.6992 83.332 82.9647 82.5975 82.2302 81.863 81.4958 81.1285 80.7613 80.394 80.0268 80.0456 80.0644 80.0831 80.1019 80.1207 80.1395 80.1583 80.177 80.1958 80.2146 80.4209 80.6272 80.8336 81.0399 81.2462 81.4525 81.6588 81.8652 82.0715 82.2778 81.8784 81.4791 81.0797 80.6804 80.281 79.8816 79.4823 79.0829 78.6836 78.2842 77.4279 76.5716 75.7153 74.859 74.0027 73.1465 72.2902 71.4339 70.5776 69.7213 69.9101 70.0989 70.2876 70.4764 70.6652 70.854 71.0428 71.2315 71.4203 71.6091 71.8831 72.1571 72.4311 72.7051 72.979 73.253 73.527 73.801 74.075 74.349 73.0745 71.8 70.5255 69.251 67.9765 66.702 65.4275 64.153 62.8785 61.604 62.4322 63.2603 64.0885 64.9166 65.7448 66.573 67.4011 68.2293 69.0574 69.8856 70.4057 70.9259 71.446 71.9662 72.4863 73.0064 73.5266 74.0467 74.5669 75.087 73.9376 72.7881 71.6387 70.4893 69.3398 68.1904 67.041 65.8916 64.7421 63.5927 61.8752 60.1578 58.4403 56.7229 55.0054 53.288 51.5705 49.8531 48.1356 46.4182 48.4569 50.4956 52.5344 54.5731 56.6118 58.6505 60.6892 62.728 64.7667 66.8054 66.4631 66.1209 65.7786 65.4364 65.0941 64.7518 64.4096 64.0673 63.7251 63.3828 63.4749 63.567 63.6592 63.7513 63.8434 63.9355 64.0276 64.1198 64.2119 64.304 63.8188 63.3336 62.8484 62.3632 61.8779 61.3927 60.9075 60.4223 59.9371 59.4519 58.7026 57.9533 57.204 56.4547 55.7054 54.9562 54.2069 53.4576 52.7083 51.959 52.5072 53.0553 53.6035 54.1516 54.6998 55.248 55.7961 56.3443 56.8924 57.4406 57.7278 58.015 58.3022 58.5894 58.8765 59.1637 59.4509 59.7381 60.0253 60.3125];
    
    % CIE 1931 XYZ 2�
    Observer.lambda = 360 : 5 : 830; % nm
    Observer.sensitivity = [
                            0.0001299 0.0002321 0.0004149 0.0007416 0.001368 0.002236 0.004243 0.00765 0.01431 0.02319 0.04351 0.07763 0.13438 0.21477 0.2839 0.3285 0.34828 0.34806 0.3362 0.3187 0.2908 0.2511 0.19536 0.1421 0.09564 0.05795001 0.03201 0.0147 0.0049 0.0024 0.0093 0.0291 0.06327 0.1096 0.1655 0.2257499 0.2904 0.3597 0.4334499 0.5120501 0.5945 0.6784 0.7621 0.8425 0.9163 0.9786 1.0263 1.0567 1.0622 1.0456 1.0026 0.9384 0.8544499 0.7514 0.6424 0.5419 0.4479 0.3608 0.2835 0.2187 0.1649 0.1212 0.0874 0.0636 0.04677 0.0329 0.0227 0.01584 0.01135916 0.008110916 0.005790346 0.004109457 0.002899327 0.00204919 0.001439971 0.0009999493 0.0006900786 0.0004760213 0.0003323011 0.0002348261 0.0001661505 0.000117413 8.307527E-05 5.870652E-05 4.150994E-05 2.935326E-05 2.067383E-05 1.455977E-05 1.025398E-05 7.221456E-06 5.085868E-06 3.581652E-06 2.522525E-06 1.776509E-06 1.251141E-06
                            3.917E-06 6.965E-06 1.239E-05 2.202E-05 3.9E-05 6.4E-05 0.00012 0.000217 0.000396 0.00064 0.00121 0.00218 0.004 0.0073 0.0116 0.01684 0.023 0.0298 0.038 0.048 0.06 0.0739 0.09098 0.1126 0.13902 0.1693 0.20802 0.2586 0.323 0.4073 0.503 0.6082 0.71 0.7932 0.862 0.9148501 0.954 0.9803 0.9949501 1 0.995 0.9786 0.952 0.9154 0.87 0.8163 0.757 0.6949 0.631 0.5668 0.503 0.4412 0.381 0.321 0.265 0.217 0.175 0.1382 0.107 0.0816 0.061 0.04458 0.032 0.0232 0.017 0.01192 0.00821 0.005723 0.004102 0.002929 0.002091 0.001484 0.001047 0.00074 0.00052 0.0003611 0.0002492 0.0001719 0.00012 8.48E-05 6E-05 4.24E-05 3E-05 2.12E-05 1.499E-05 1.06E-05 7.4657E-06 5.2578E-06 3.7029E-06 2.6078E-06 1.8366E-06 1.2934E-06 9.1093E-07 6.4153E-07 4.5181E-07
                            0.0006061 0.001086 0.001946 0.003486 0.006450001 0.01054999 0.02005001 0.03621 0.06785001 0.1102 0.2074 0.3713 0.6456 1.0390501 1.3856 1.62296 1.74706 1.7826 1.77211 1.7441 1.6692 1.5281 1.28764 1.0419 0.8129501 0.6162 0.46518 0.3533 0.272 0.2123 0.1582 0.1117 0.07824999 0.05725001 0.04216 0.02984 0.0203 0.0134 0.008749999 0.005749999 0.0039 0.002749999 0.0021 0.0018 0.001650001 0.0014 0.0011 0.001 0.0008 0.0006 0.00034 0.00024 0.00019 1E-04 4.999999E-05 3E-05 2E-05 1E-05 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
                           ];
    
    %% Parse inputs
    
    lambda = linspace(min(lam_lims), max(lam_lims), f_qty);
    
    Filters.T_ = zeros(Filters.qty, length(lambda)); % resample to match lambda domain
    for f = 1 : Filters.qty
        Filters.T_(f,:) = spline(Filters.lambda, Filters.T(f,:), lambda);
    end
    
    % Prevent range violations due to spline interpolation
    Filters.T_(Filters.T_<0) = 0;
    Filters.T_(Filters.T_>1) = 1;
    
    % Resample to align domains
    Illuminant.power = interp1(Illuminant.lambda, Illuminant.lambda, lambda);
    Illuminant.lambda = lambda;
    sen = zeros(3,length(lambda));
    for cc = 1 : 3
        sen(cc,:) = interp1(Observer.lambda, Observer.sensitivity(cc,:), lambda);
    end
    Observer.sensitivity = sen;
    Observer.lambda = lambda;
    N = sum(Illuminant.power .* Observer.sensitivity(2,:)); % for scaling XYZ
    
    %% Build stacked filters
    
    Stacks.qty = Filters.qty + Filters.qty^2;
    
    Stacks.ind = cell(Stacks.qty, 1);
    Stacks.T = zeros(Stacks.qty, length(lambda));
    Stacks.T_norm = zeros(size(Stacks.T));
    
    s = 1; % stack index
    
    % One filter
    for f1 = 1 : Filters.qty
        Stacks.ind{s} = f1;
        Stacks.T(s,:) = Filters.T_(f1,:);
        s = s + 1;
    end
    
    % Two filters
    for f1 = 1 : Filters.qty
        for f2 = 1 : Filters.qty
            Stacks.ind{s} = [f1 f2];
            Stacks.T(s,:) = Filters.T_(f1,:) .* Filters.T_(f2,:);
            s = s + 1;
        end
    end
    
    % Create normalized copies
    for row = 1 : Stacks.qty
        Stacks.T_norm(row,:) = Stacks.T(row,:) ./ norm(Stacks.T(row,:));
    end
    
    % Total transmission
    Stacks.T_sum = sum(Stacks.T,2) ./ size(Stacks.T,2);
    
    %%
    
    % Initialize the optimized set
    Set.desc = cell(length(lambda), 1);
    Set.T    = ones(length(lambda), size(Filters.T,2));
    Set.T_    = ones(length(lambda), size(Filters.T_,2));
    Set.lambda = Filters.lambda;
    Set.qty    = length(lambda);
    Set.XYZ    = zeros(length(lambda), 3);
    Set.RGB    = zeros(length(lambda), 3);
    Set.T_limits = t_lims;
    Set.dot = zeros(length(lambda), 1);
    
    usage = zeros(1, Filters.qty); % record how many times a filter has been used
    
    for w = 1 : length(lambda) % for each wavelength index
        
        T_ideal = zeros(length(lambda), 1);
        T_ideal(w) = 1;
            
        dots = Stacks.T_norm(:,w); % dot product with ideal transmission
        
        % Apply overall transmission constraint
        dots(Stacks.T_sum < min(t_lims)) = 0;
        dots(Stacks.T_sum > max(t_lims)) = 0;
        
        % Apply usage constraint
        ind_depleted = find(usage >= use_max);
        found_valid = 0;
        while ~found_valid
            [~, ind_best] = max(dots);
            ind_requires = Stacks.ind{ind_best};
            if isempty(intersect(ind_requires, ind_depleted))
                % Valid
                break
            else
                % Not valid; zero the score and find the next best one
                dots(ind_best) = 0;
            end
        end
        
        [dot_best, ind_best] = max(dots);
        
        str_desc = '';
        for f = 1:length(Stacks.ind{ind_best})
            str_desc = [str_desc Filters.name{Stacks.ind{ind_best}(f)} ', '];
        end
        str_desc = str_desc(1:end-2);
        
        % Save to set
        Set.dot(w) = dot_best;
        Set.desc{w} = str_desc;
        for f = 1 : length(Stacks.ind{ind_best})
            Set.T(w,:) = Set.T(w,:) .* Filters.T(Stacks.ind{ind_best}(f), :);
            Set.T_(w,:) = Set.T_(w,:) .* Filters.T_(Stacks.ind{ind_best}(f), :);
        end
        for cc = 1 : 3
            Set.XYZ(w,cc) = sum(Illuminant.power .* Observer.sensitivity(cc,:) .* Set.T_(w,:)) / N;
        end
        Set.RGB(w,:) = xyz2rgb(Set.XYZ(w,:), 'WhitePoint', 'D65');
        
        % Record usage
        for f = 1 : length(Stacks.ind{ind_best})
            usage(Stacks.ind{ind_best}(f)) = usage(Stacks.ind{ind_best}(f)) + 1;
        end
        
%         figure(1)
%             clf
%             hold on
%             set(gcf,'color','white')
%             plot(lambda, T_ideal, 'k', 'LineWidth', 2)
%             plot(lambda, Stacks.T(ind_best,:), 'r', 'LineWidth', 2)
%             grid on
%             grid minor
%             for f = 1:length(Stacks.ind{ind_best})
%                 plot(lambda, Filters.T_(Stacks.ind{ind_best}(f),:), 'Color', zeros(1,3)+0.50)
%             end
%             xlabel('Wavelength, nm')
%             ylabel('Transmission, 0-1, ~')
%             title({
%                     ['\fontsize{10}Target: ' num2str(round(lambda(w)*10)/10) ' nm, Best Dot: '  num2str(round(dots(ind_best)*1000)/10) '%']
%                     ['\rm\fontsize{8}' regexprep(str_desc, '\_', '\\_')]
%                     ['Overall transmission: ' num2str(round(Stacks.T_sum(ind_best)*1000)/10) '%, Constrained to [' num2str(round(min(t_lims)*1000)/10) ', ' num2str(round(max(t_lims)*1000)/10) '%]']
%                  })
%             ylim([0 1])
%             drawnow
        
%         disp([num2str(lambda(w)) ' nm: ' regexprep(str_desc,'roscolux_','') ', ' num2str(round(dots(ind_best)*1000)/10) '%' ])

%         % Capture the frame
%         frame = getframe(gcf); 
%         im = frame2im(frame); 
%         [imind,cm] = rgb2ind(im,256);
%         if w == 1
%             imwrite(imind,cm, GIF_fn,'gif', 'Loopcount',inf,'DelayTime',1/GIF_fps);
%         else 
%             imwrite(imind,cm, GIF_fn,'gif','WriteMode','append','DelayTime',1/GIF_fps); 
%         end

%         pause
        
    end
    
    % Normalize 0-1
    Set.RGB = (Set.RGB-min(Set.RGB(:))) ./ (max(Set.RGB(:))-min(Set.RGB(:)));
    
    Set.lambda_coarse = lambda;
    
    Set.name = cell(Set.qty,1);
    for f = 1 : Set.qty
        Set.name{f} = ['#' num2str(f) ', ' num2str(lambda(f)) ' nm: ' Set.desc{f}];
        disp(Set.name{f})
    end
    
    %% Show set
    
    lam_fine = min(Set.lambda) : 5 : max(Set.lambda); % nm
    
    figure(2)
        clf
        hold on
        set(gcf,'color','white')
        
    h = max(ylim);
    dh = 0.079;
    for f = 1 : Set.qty
        y = spline(Set.lambda, Set.T(f,:), lam_fine);
        y(y<0) = 0;
        plot(lam_fine, y, 'Color', Set.RGB(f,:), 'LineWidth', 3)
        text(max(xlim), h, ['\bf#' num2str(f) ', ' num2str(lambda(f)) ' nm: \rm' regexprep(Set.desc{f},'\_','\\_')], 'HorizontalAlignment','left','VerticalAlignment','top','FontSize', 9, 'BackgroundColor', Set.RGB(f,:))
        h = h - dh;
    end
    
    grid on
    grid minor
    axis([min(Set.lambda) max(Set.lambda) 0 1])
    xlabel('Wavelength, nm')
    ylabel('Transmission Fraction, 0-1, ~')
    str_constraints = ['\rm\fontsize{10}Constraints: ' num2str(mean(t_lims)*100) ' � ' num2str(abs(diff(t_lims)/2)*100) '% Overall Transmission, \leq ' num2str(use_max) ' Uses Per Filter, \leq 2 Filters Per Stack'  ];
    title({
            'Roscolux Stacked Filter Set, Optimized For Visible Light Hyperspectral Imaging'
            str_constraints
         })
    
    pos = get(gcf,'position');
    set(gcf,'position',[pos(1:2) 1100 500])
    set(gca,'position',[0.05 0.10 0.62 0.80])
    
    figure(3)
        clf
        hold on
        set(gcf,'color','white')
        xlim([min(lambda) max(lambda)])
        plot(xlim, zeros(1,2)+mean(Set.dot), 'r', 'LineWidth', 2)
        plot(lambda, Set.dot, 'k-o')
        grid on
        grid minor
        xlabel('Wavelength, nm')
        ylabel('Dot, Norm. Filter Trans. and Ideal Spike, 0-1')
        title({
                ['Optimized Filter Set Orthogonality: Mean = ' num2str(round(mean(Set.dot)*100)) '%']
                str_constraints
             })
        xlim([min(lambda) max(lambda)])
        ylim([0 1])


% end


















































