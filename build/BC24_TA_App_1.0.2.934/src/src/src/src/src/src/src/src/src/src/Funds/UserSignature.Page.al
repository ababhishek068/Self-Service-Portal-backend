page 50538 "User Signature"
{
    Caption = 'User Signature';
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = CardPart;
    SourceTable = "User Setup";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            field("User Signature"; Rec."User Signature")
            {
                ApplicationArea = All;
                ShowCaption = false;
                ToolTip = 'Specifies the user Signature';
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(TakePicture)
            {
                ApplicationArea = All;
                Caption = 'Take';
                Image = Camera;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Activate the camera on the device.';
                Visible = true;

                trigger OnAction()
                begin
                    TakeNewPicture;
                end;
            }
            action(ImportPicture)
            {
                ApplicationArea = All;
                Caption = 'Import';
                Image = Import;
                ToolTip = 'Import a picture file.';

                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    FileName: Text;
                    ClientFileName: Text;

                begin
                    Rec.TestField("User ID");
                    if Rec.UserName = '' then
                        Error(MustSpecifyNameErr);

                    if "User Signature".HasValue then
                        if not Confirm(OverrideImageQst) then
                            exit;

                    FileName := FileManagement.UploadFile(SelectPictureTxt, ClientFileName);
                    if FileName = '' then
                        exit;

                    Clear(Rec."User Signature");
                    "User Signature".Import(FileName);
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
                ToolTip = 'Export the picture to a file.';

                trigger OnAction()
                var
                    DummyPictureEntity: Record "Picture Entity";
                    FileManagement: Codeunit "File Management";
                    ToFile: Text;
                    ExportPath: Text;
                begin
                    Rec.TestField("User ID");
                    Rec.TestField(UserName);

                    ToFile := DummyPictureEntity.GetDefaultMediaDescription(Rec);
                    ExportPath := TemporaryPath + Rec."User ID";
                    "User Signature".Export(ExportPath);

                    FileManagement.ExportImage(ExportPath, ToFile);
                end;
            }
            action(DeletePicture)
            {
                ApplicationArea = All;
                Caption = 'Delete';
                Enabled = DeleteExportEnabled;
                Image = Delete;
                ToolTip = 'Delete the record.';

                trigger OnAction()
                begin
                    Rec.TestField("User ID");

                    if not Confirm(DeleteImageQst) then
                        exit;

                    Clear(Rec."User Signature");
                    Rec.Modify(true);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetEditableOnPictureActions;
    end;

    trigger OnOpenPage()
    begin
        CameraAvailable := Camera.IsAvailable();
    end;

    var
        Camera: Page Camera;
        [InDataSet]
        CameraAvailable: Boolean;
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        SelectPictureTxt: Label 'Select a picture to upload';
        DeleteExportEnabled: Boolean;
        MustSpecifyNameErr: Label 'You must specify a employee name before you can import a picture.';

    procedure TakeNewPicture()
    var
        InStream: InStream;
    begin
        Rec.Find;
        Rec.TestField("User ID");
        // TestField("First Name");

        if not CameraAvailable then
            exit;

        Camera.RunModal();
        if Camera.HasPicture() then begin
            if "User Signature".HasValue then
                if not Confirm(OverrideImageQst) then
                    exit;

            Camera.GetPicture(Instream);

            Clear(Rec."User Signature");
            // "User Signature".ImportStream(Instream, 'Signature Picture');
            if not Rec.Modify(true) then
                Rec.Insert(true);
        end;

        Clear(Camera);
    end;

    local procedure SetEditableOnPictureActions()
    begin
        DeleteExportEnabled := "User Signature".HasValue;
    end;

    procedure IsCameraAvailable(): Boolean
    begin
        // exit(Camera.IsAvailable());
        exit(true);
    end;
}
