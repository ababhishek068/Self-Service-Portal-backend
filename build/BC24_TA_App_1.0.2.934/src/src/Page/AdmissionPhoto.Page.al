page 50951 "Admission Photo"
{
    Caption = 'Admission Photo';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = "Admission Form Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field(Photo; Rec.Photo)
            {
                ApplicationArea = All;
                ShowCaption = false;
                ToolTip = 'Specifies the Photo of the Applicant';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(TakePhoto)
            {
                ApplicationArea = All;
                Caption = 'Take';
                Image = Camera;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Activate the camera on the device.';
                Visible = CameraAvailable;

                trigger OnAction()
                begin
                    TakeNewPhoto;
                end;
            }
            action(ImportPhoto)
            {
                ApplicationArea = All;
                Caption = 'Import';
                Image = Import;
                ToolTip = 'Import a Photo file.';

                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    FileName: Text;
                    ClientFileName: Text;
                begin
                    Rec.TestField("Admission No.");
                    if Rec.Surname = '' then
                        Error(MustSpecifyNameErr);

                    if Photo.HasValue then
                        if not Confirm(OverrideImageQst) then
                            exit;

                    FileName := FileManagement.UploadFile(SelectPhotoTxt, ClientFileName);
                    if FileName = '' then
                        exit;

                    Clear(Rec.Photo);
                    Photo.ImportFile(FileName, ClientFileName);
                    if not Rec.Modify(true) then
                        Rec.Insert(true);

                    if FileManagement.DeleteServerFile(FileName) then;
                end;
            }
            action(ExportFile)
            {
                ApplicationArea = All;
                Caption = 'Export';
                Enabled = DeleteExportEnabled;
                Image = Export;
                ToolTip = 'Export the Photo to a file.';

                trigger OnAction()
                var
                    DummyPhotoEntity: Record "Picture Entity";
                    FileManagement: Codeunit "File Management";
                    ToFile: Text;
                    ExportPath: Text;
                begin
                    Rec.TestField("Admission No.");
                    Rec.TestField(Surname);

                    ToFile := DummyPhotoEntity.GetDefaultMediaDescription(Rec);
                    ExportPath := TemporaryPath + Rec."Admission No." + Format(Photo.MediaId);
                    Photo.ExportFile(ExportPath);

                    FileManagement.ExportImage(ExportPath, ToFile);
                end;
            }
            action(DeletePhoto)
            {
                ApplicationArea = All;
                Caption = 'Delete';
                Enabled = DeleteExportEnabled;
                Image = Delete;
                ToolTip = 'Delete the record.';

                trigger OnAction()
                begin
                    Rec.TestField("Admission No.");

                    if not Confirm(DeleteImageQst) then
                        exit;

                    Clear(Rec.Photo);
                    Rec.Modify(true);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPhotoActions;
    end;

    trigger OnOpenPage()
    begin
        CameraAvailable := Camera.IsAvailable();
    end;

    var
        Camera: Page Camera;
        [InDataSet]
        CameraAvailable: Boolean;
        OverrideImageQst: Label 'The existing Photo will be replaced. Do you want to continue?';
        DeleteImageQst: Label 'Are you sure you want to delete the Photo?';
        SelectPhotoTxt: Label 'Select a Photo to upload';
        DeleteExportEnabled: Boolean;
        MustSpecifyNameErr: Label 'You must specify a customer name before you can import a Photo.';

    procedure TakeNewPhoto()
    var
        InStream: InStream;
    begin
        Rec.Find;
        Rec.TestField("Admission No.");
        Rec.TestField(Surname);

        if not CameraAvailable then
            exit;

        Camera.RunModal();
        if Camera.HasPicture() then begin
            if Photo.HasValue then
                if not Confirm(OverrideImageQst) then
                    exit;

            Camera.GetPicture(Instream);

            Clear(Rec.Photo);
            Photo.ImportStream(Instream, 'Customer Photo');
            if not Rec.Modify(true) then
                Rec.Insert(true);
        end;

        Clear(Camera);
    end;

    local procedure SetEditableOnPhotoActions()
    begin
        DeleteExportEnabled := Photo.HasValue;
    end;

    procedure IsCameraAvailable(): Boolean
    begin
        exit(Camera.IsAvailable());
    end;
}
