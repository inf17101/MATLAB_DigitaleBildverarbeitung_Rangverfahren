classdef guiApp_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                        matlab.ui.Figure
        InputBildDropDownLabel          matlab.ui.control.Label
        InputBildDropDown               matlab.ui.control.DropDown
        PixelumgebungDropDownLabel      matlab.ui.control.Label
        PixelumgebungDropDown           matlab.ui.control.DropDown
        SchwellenwertEditFieldLabel     matlab.ui.control.Label
        SchwellenwertEditField          matlab.ui.control.NumericEditField
        AlgorithmusRangverfahrenLabel   matlab.ui.control.Label
        StartButton                     matlab.ui.control.StateButton
        Image                           matlab.ui.control.Image
        Image2                          matlab.ui.control.Image
        Image3                          matlab.ui.control.Image
        OrginalbildLabel                matlab.ui.control.Label
        ErgebnisnachSobelLabel          matlab.ui.control.Label
        ErgebnisnachRangverfahrenLabel  matlab.ui.control.Label
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
            threshold = app.SchwellenwertEditField.Value;
            [InputPicture, SobelMatrix, GradientenMatrix] = Rangverfahren(input_file, index, threshold);
            app.pic_filename = [tempname(pwd), '.png']; % create new random filename
            imwrite(SobelMatrix, app.pic_filename);
            app.Image2.ImageSource = app.pic_filename;
            app.pic_filename = [tempname(pwd), '.png'];
            imwrite(SobelMatrix, app.pic_filename);
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
            app.InputBildDropDownLabel.Position = [332 587 56 22];
            app.InputBildDropDownLabel.Text = 'Input-Bild';

            % Create InputBildDropDown
            app.InputBildDropDown = uidropdown(app.UIFigure);
            app.InputBildDropDown.Items = {'Bild ausw�hlen', '6EckPic.png', 'Gimp2.png', 'GimpPicture.png', 'Kreis20px.png', 'KreisFarbverlauf2_800px.png', 'KreisFarbverlauf800px.png', 'Kreis_NoSmooth20px.png', 'ManyForms200px.png', 'ManyForms600px.png', 'PicTest600px.png', 'SelbstmalKreis800px.png', 'SPicture_Saved.png', 'SternPic.png', 'Testbild_9x9.png', 'Testbild_Fuchs.png', 'Testbild_Kreis_100x100.png', 'testbild_saved.png', 'Xpic600px.png', 'ZugPic.png'};
            app.InputBildDropDown.ValueChangedFcn = createCallbackFcn(app, @InputBildDropDownValueChanged, true);
            app.InputBildDropDown.Position = [403 587 138 22];
            app.InputBildDropDown.Value = 'Bild ausw�hlen';

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

            % Create SchwellenwertEditFieldLabel
            app.SchwellenwertEditFieldLabel = uilabel(app.UIFigure);
            app.SchwellenwertEditFieldLabel.HorizontalAlignment = 'right';
            app.SchwellenwertEditFieldLabel.Position = [684 550 83 22];
            app.SchwellenwertEditFieldLabel.Text = 'Schwellenwert';

            % Create SchwellenwertEditField
            app.SchwellenwertEditField = uieditfield(app.UIFigure, 'numeric');
            app.SchwellenwertEditField.Limits = [0 50];
            app.SchwellenwertEditField.Position = [787 550 100 22];

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
            app.StartButton.Position = [403 550 100 22];

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

            % Create ErgebnisnachSobelLabel
            app.ErgebnisnachSobelLabel = uilabel(app.UIFigure);
            app.ErgebnisnachSobelLabel.Position = [543 466 116 22];
            app.ErgebnisnachSobelLabel.Text = 'Ergebnis nach Sobel';

            % Create ErgebnisnachRangverfahrenLabel
            app.ErgebnisnachRangverfahrenLabel = uilabel(app.UIFigure);
            app.ErgebnisnachRangverfahrenLabel.Position = [889 466 165 22];
            app.ErgebnisnachRangverfahrenLabel.Text = 'Ergebnis nach Rangverfahren';

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