classdef guiApp_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        InputBildDropDownLabel          matlab.ui.control.Label
        InputBildDropDown               matlab.ui.control.DropDown
        PixelumgebungDropDownLabel      matlab.ui.control.Label
        PixelumgebungDropDown           matlab.ui.control.DropDown
        SchwellenwertRangverfahrenLabel  matlab.ui.control.Label
        SchwellenwertRangverfahrenEditField  matlab.ui.control.NumericEditField
        AlgorithmusRangverfahrenLabel   matlab.ui.control.Label
        StartButton                     matlab.ui.control.StateButton
        Image                           matlab.ui.control.Image
        Image2                          matlab.ui.control.Image
        Image3                          matlab.ui.control.Image
        OrginalbildLabel                matlab.ui.control.Label
        ErgebnisnachGradientenbetragsbildmitSchwellwertLabel  matlab.ui.control.Label
        ErgebnisnachRangverfahrenLabel  matlab.ui.control.Label
        SchwellwertSobelEditFieldLabel  matlab.ui.control.Label
        SchwellwertSobelEditField       matlab.ui.control.NumericEditField
        AutoSchwellwertCheckBox         matlab.ui.control.CheckBox
        PaddingOptionenButtonGroup      matlab.ui.container.ButtonGroup
        PaddingButton                   matlab.ui.control.RadioButton
        PeriodischeFortsetzungButton    matlab.ui.control.RadioButton
    end

    
    properties (Access = public)
        pic_filename % filename for saved Images (for temporary changing filenames)
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Value changed function: StartButton
        function StartButtonValueChanged(app, event)
            %value = app.StartButton.Value;
            input_file = strcat('images/', app.InputBildDropDown.Value);
            index = app.PixelumgebungDropDown.Value;
            threshold_rang = app.SchwellenwertRangverfahrenEditField.Value;
            threshold_sobel = app.SchwellwertSobelEditField.Value;
            auto_threshold_activated = app.AutoSchwellwertCheckBox.Value;
            zero_padding_selection = app.PaddingButton.Value;
            if zero_padding_selection == 1
                selected_padding_type = 0;
            else
                selected_padding_type = 1;
            end
            
            [~, SobelMatrix, GradientenMatrix] = Rangverfahren(input_file, index, threshold_rang, threshold_sobel, auto_threshold_activated, selected_padding_type);
            app.pic_filename = [tempname(pwd), '.png']; % create new random filename
            imwrite(SobelMatrix, app.pic_filename);
            app.Image2.ImageSource = app.pic_filename;
            app.pic_filename = [tempname(pwd), '.png'];
            imwrite(GradientenMatrix, app.pic_filename);
            app.Image3.ImageSource = app.pic_filename;
        end

        % Value changed function: InputBildDropDown
        function InputBildDropDownValueChanged(app, event)
            value = strcat('images/', app.InputBildDropDown.Value);
            app.Image.ImageSource = value;
        end

        % Close request function: UIFigure
        function UIFigureCloseRequest(app, event)
            delete *.png;
            delete(app)
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 1200 700];
            app.UIFigure.Name = 'UI Figure';
            app.UIFigure.CloseRequestFcn = createCallbackFcn(app, @UIFigureCloseRequest, true);

            % Create InputBildDropDownLabel
            app.InputBildDropDownLabel = uilabel(app.UIFigure);
            app.InputBildDropDownLabel.HorizontalAlignment = 'right';
            app.InputBildDropDownLabel.Position = [176 587 56 22];
            app.InputBildDropDownLabel.Text = 'Input-Bild';

            % Create InputBildDropDown
            app.InputBildDropDown = uidropdown(app.UIFigure);
            app.InputBildDropDown.Items = {'6EckPic.png', 'Gimp2.png', 'GimpPicture.png', 'Kreis20px.png', 'KreisFarbverlauf2_800px.png', 'KreisFarbverlauf800px.png', 'Kreis_NoSmooth20px.png', 'ManyForms200px.png', 'ManyForms600px.png', 'PicTest600px.png', 'SelbstmalKreis800px.png', 'SPicture_Saved.png', 'SternPic.png', 'Testbild_9x9.png', 'Testbild_Fuchs.png', 'Testbild_Kreis_100x100.png', 'testbild_saved.png', 'Xpic600px.png', 'TestSimple7x7.png', 'ZugPic.png', 'TestSimple8x8.png', 'Kreis2pxKante80px.png', 'TestSimple9x9.png'};
            app.InputBildDropDown.ValueChangedFcn = createCallbackFcn(app, @InputBildDropDownValueChanged, true);
            app.InputBildDropDown.Position = [247 587 138 22];
            app.InputBildDropDown.Value = '6EckPic.png';

            % Create PixelumgebungDropDownLabel
            app.PixelumgebungDropDownLabel = uilabel(app.UIFigure);
            app.PixelumgebungDropDownLabel.HorizontalAlignment = 'right';
            app.PixelumgebungDropDownLabel.Position = [684 587 88 22];
            app.PixelumgebungDropDownLabel.Text = 'Pixelumgebung';

            % Create PixelumgebungDropDown
            app.PixelumgebungDropDown = uidropdown(app.UIFigure);
            app.PixelumgebungDropDown.Items = {'3x3 Umgebung', '5x5 Umgebung', '7x7 Umgebung'};
            app.PixelumgebungDropDown.ItemsData = {'1', '2', '3'};
            app.PixelumgebungDropDown.Position = [787 587 100 22];
            app.PixelumgebungDropDown.Value = '1';

            % Create SchwellenwertRangverfahrenLabel
            app.SchwellenwertRangverfahrenLabel = uilabel(app.UIFigure);
            app.SchwellenwertRangverfahrenLabel.HorizontalAlignment = 'right';
            app.SchwellenwertRangverfahrenLabel.Position = [601 550 166 22];
            app.SchwellenwertRangverfahrenLabel.Text = 'Schwellenwert Rangverfahren';

            % Create SchwellenwertRangverfahrenEditField
            app.SchwellenwertRangverfahrenEditField = uieditfield(app.UIFigure, 'numeric');
            app.SchwellenwertRangverfahrenEditField.Limits = [0 50];
            app.SchwellenwertRangverfahrenEditField.Position = [787 550 100 22];

            % Create AlgorithmusRangverfahrenLabel
            app.AlgorithmusRangverfahrenLabel = uilabel(app.UIFigure);
            app.AlgorithmusRangverfahrenLabel.FontSize = 26;
            app.AlgorithmusRangverfahrenLabel.FontWeight = 'bold';
            app.AlgorithmusRangverfahrenLabel.Position = [424 629 354 31];
            app.AlgorithmusRangverfahrenLabel.Text = 'Algorithmus Rangverfahren';

            % Create StartButton
            app.StartButton = uibutton(app.UIFigure, 'state');
            app.StartButton.ValueChangedFcn = createCallbackFcn(app, @StartButtonValueChanged, true);
            app.StartButton.Text = 'Start';
            app.StartButton.FontWeight = 'bold';
            app.StartButton.Position = [247 550 100 22];

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [73 160 315 282];

            % Create Image2
            app.Image2 = uiimage(app.UIFigure);
            app.Image2.Position = [427 160 347 282];

            % Create Image3
            app.Image3 = uiimage(app.UIFigure);
            app.Image3.Position = [821 160 299 282];

            % Create OrginalbildLabel
            app.OrginalbildLabel = uilabel(app.UIFigure);
            app.OrginalbildLabel.Position = [199 466 63 22];
            app.OrginalbildLabel.Text = 'Orginalbild';

            % Create ErgebnisnachGradientenbetragsbildmitSchwellwertLabel
            app.ErgebnisnachGradientenbetragsbildmitSchwellwertLabel = uilabel(app.UIFigure);
            app.ErgebnisnachGradientenbetragsbildmitSchwellwertLabel.Position = [453 466 295 22];
            app.ErgebnisnachGradientenbetragsbildmitSchwellwertLabel.Text = 'Ergebnis nach Gradientenbetragsbild mit Schwellwert';

            % Create ErgebnisnachRangverfahrenLabel
            app.ErgebnisnachRangverfahrenLabel = uilabel(app.UIFigure);
            app.ErgebnisnachRangverfahrenLabel.Position = [889 466 165 22];
            app.ErgebnisnachRangverfahrenLabel.Text = 'Ergebnis nach Rangverfahren';

            % Create SchwellwertSobelEditFieldLabel
            app.SchwellwertSobelEditFieldLabel = uilabel(app.UIFigure);
            app.SchwellwertSobelEditFieldLabel.HorizontalAlignment = 'right';
            app.SchwellwertSobelEditFieldLabel.Position = [937 587 103 22];
            app.SchwellwertSobelEditFieldLabel.Text = 'Schwellwert Sobel';

            % Create SchwellwertSobelEditField
            app.SchwellwertSobelEditField = uieditfield(app.UIFigure, 'numeric');
            app.SchwellwertSobelEditField.Position = [1055 587 100 22];

            % Create AutoSchwellwertCheckBox
            app.AutoSchwellwertCheckBox = uicheckbox(app.UIFigure);
            app.AutoSchwellwertCheckBox.Text = ' Auto-Schwellwert';
            app.AutoSchwellwertCheckBox.Position = [787 510 118 22];

            % Create PaddingOptionenButtonGroup
            app.PaddingOptionenButtonGroup = uibuttongroup(app.UIFigure);
            app.PaddingOptionenButtonGroup.Title = 'Padding Optionen';
            app.PaddingOptionenButtonGroup.Position = [424 532 164 77];

            % Create PaddingButton
            app.PaddingButton = uiradiobutton(app.PaddingOptionenButtonGroup);
            app.PaddingButton.Text = '0-Padding';
            app.PaddingButton.Position = [11 31 77 22];
            app.PaddingButton.Value = true;

            % Create PeriodischeFortsetzungButton
            app.PeriodischeFortsetzungButton = uiradiobutton(app.PaddingOptionenButtonGroup);
            app.PeriodischeFortsetzungButton.Text = 'Periodische Fortsetzung';
            app.PeriodischeFortsetzungButton.Position = [11 9 151 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = guiApp_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end