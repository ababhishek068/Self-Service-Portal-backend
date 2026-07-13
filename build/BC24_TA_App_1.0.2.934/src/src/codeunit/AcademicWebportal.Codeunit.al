
Codeunit 50032 AcademicWebportal
{
    trigger OnRun()
    begin

    end;

    var
        RegistrationForm: Record "Registration Form";
        CourseSelection: Record "Course Selection List";
        RegQualification: Record "Registration Qualifications";

    procedure UpdateRegistrationInformation(ServiceNo: Code[20]; Village: Text[50]; Location: Text[50]; VElderName: Text[50]; VElderContact: Text[50];
     ChiefName: Text[50]; ChiefContact: Text[50]; AssChiefName: Text[50]; AssChiefContact: Text[50]; PoliceStation: Text[50]; Town: Text[50]; FName: Text[50];
      FContact: Text[50]; FAlive: Integer; MName: Text[50]; MContact: Text[50]; MAlive: Integer; GName: Text[50]; GContact: Text[50]; Denomination: Code[20])

    begin
        RegistrationForm.Reset;
        RegistrationForm.SetRange("Service Number", ServiceNo);
        if RegistrationForm.Find('-') then begin
            RegistrationForm."Location/Sublocation" := Location;
            RegistrationForm."Nearest Village" := Village;
            RegistrationForm."Village Elder Name" := VElderName;
            RegistrationForm."Village Elder Contact" := VElderContact;
            RegistrationForm."Chief's Name" := ChiefName;
            RegistrationForm."Chief's Contact" := ChiefContact;
            RegistrationForm."Assist. Chief Name" := AssChiefName;
            RegistrationForm."Assist. Chief Contact" := AssChiefContact;
            RegistrationForm."Nearest Police Station" := PoliceStation;
            RegistrationForm."Nearest Town" := Town;
            RegistrationForm."Father's Name" := FName;
            RegistrationForm."Father's Contacts" := FContact;
            RegistrationForm."Father Alive/Deceased" := FAlive;
            RegistrationForm."Mother's Name" := MName;
            RegistrationForm."Mother's Contact" := MContact;
            RegistrationForm."Mother Alive/Deceased" := MAlive;
            RegistrationForm."Gurdian's Name" := GName;
            RegistrationForm."Gurdian's Contact" := GContact;
            RegistrationForm.Denomination := Denomination;
            RegistrationForm.Modify();
        end;
    end;

    procedure UploadProfilePic(ServiceNo: Code[20]; FileName: Text; Attachment: BigText)
    var
        DocAttachment: Record "Document Attachment";
        FromRecRef: RecordRef;
        FileManagement: Codeunit "File Management";
    begin
        RegistrationForm.Reset;
        RegistrationForm.SetRange("Serial No", ServiceNo);
        if RegistrationForm.Find('-') then begin
            FromRecRef.GETTABLE(RegistrationForm);
            if FileName <> '' then begin
                Clear(DocAttachment);
                DocAttachment.Init();
                DocAttachment.Validate("File Extension", FileManagement.GetExtension(FileName));
                DocAttachment.Validate("File Name", CopyStr(FileManagement.GetFileNameWithoutExtension(FileName), 1, MaxStrLen(FileName)));
                DocAttachment.Validate("Table ID", FromRecRef.Number);
                DocAttachment.Validate("No.", ServiceNo);
                // Bytes := Convert.FromBase64String(Attachment);
                // MemoryStream := MemoryStream.MemoryStream(Bytes);
                // DocAttachment."Document Reference ID".ImportStream(MemoryStream, '', FileName);
                DocAttachment.Insert(true);
                if FileManagement.DeleteServerFile(FileName) then;
            end else
                Error('No file to upload');
        end;
    end;

    procedure GetProfilePicture(ServiceNo: Text) BaseImage: Text
    var
        IStream: InStream;
        // Bytes: dotnet Array;
        // Convert: dotnet Convert;
        // MemoryStream: dotnet MemoryStream;
        TenantMedia: Record "Tenant Media";
        imageID: GUID;
    begin
        RegistrationForm.Reset;
        RegistrationForm.SetRange("Serial No", ServiceNo);
        if RegistrationForm.Find('-') then begin
            if RegistrationForm."Applicant Photo".Hasvalue then begin
                imageID := RegistrationForm."Applicant Photo".MediaId;
                IF TenantMedia.GET(imageID) THEN BEGIN
                    TenantMedia.CALCFIELDS(Content);
                    TenantMedia.Content.CreateInstream(IStream);
                    // MemoryStream := MemoryStream.MemoryStream();
                    // CopyStream(MemoryStream, IStream);
                    // Bytes := MemoryStream.GetBuffer();
                    // BaseImage := Convert.ToBase64String(Bytes);
                END;
            end;
        end;
    end;

    procedure InsertApplicantProgrammeOptions(ServiceNo: Code[20]; ProgOption1: Code[20]; ProgOption2: Code[20]; ProgOption3: Code[20])
    begin
        RegistrationForm.Reset;
        RegistrationForm.SetRange("Service Number", ServiceNo);
        if RegistrationForm.Find('-') then begin
            RegistrationForm."First Choice Programme" := ProgOption1;
            RegistrationForm."Second Choice Programme" := ProgOption2;
            RegistrationForm."Third Choice Programme" := ProgOption3;
            RegistrationForm.Modify();

            CourseSelection.Init();
            CourseSelection."Service No" := ServiceNo;
            CourseSelection."First Choice Programme" := ProgOption1;
            CourseSelection."Second Choice Programme" := ProgOption2;
            CourseSelection."Third Choice Programme" := ProgOption3;
            CourseSelection."Selection No" := CourseSelection."Selection No"::"First Selection";
            CourseSelection.Insert();
        end;
    end;

    procedure UpdateApplicantProgrammeOptions(ServiceNo: Code[20]; ProgOption: Code[20]; OptionNo: Integer)
    begin
        RegistrationForm.Reset;
        RegistrationForm.SetRange("Service Number", ServiceNo);
        if RegistrationForm.Find('-') then begin
            CourseSelection.Reset;
            CourseSelection.SetRange("Service No", ServiceNo);
            if CourseSelection.Find('-') then begin
                if (OptionNo = 1) then begin
                    RegistrationForm."First Choice Programme" := ProgOption;
                    CourseSelection."First Choice Programme" := ProgOption;
                end;

                if (OptionNo = 2) then begin
                    RegistrationForm."Second Choice Programme" := ProgOption;
                    CourseSelection."Second Choice Programme" := ProgOption;
                end;

                if (OptionNo = 3) then begin
                    RegistrationForm."Third Choice Programme" := ProgOption;
                    CourseSelection."Third Choice Programme" := ProgOption;
                end;
                RegistrationForm.Modify();
                CourseSelection.Modify();
            end;
        end;
    end;

    procedure ApplicantAcademicQualification(ServiceNo: Code[20]; SubjectCode: Code[20]; Grade: Code[20])
    begin
        RegQualification.Reset;
        RegQualification.SetRange("Service No.", ServiceNo);
        RegQualification.SetRange("Subject Code", SubjectCode);
        if RegQualification.Find('-') then begin
            RegQualification.Grade := Grade;
            RegQualification.Modify();
        end else begin
            RegQualification.Init();
            RegQualification."Service No." := ServiceNo;
            RegQualification."Subject Code" := SubjectCode;
            RegQualification.Grade := Grade;
            RegQualification.Insert();
        end;
    end;

    procedure InsertAdmissionHeader(Surname: Text; Names: Text; Programme: Text; DOB: Date; Gender: Option; Email: Text; Region: Text; Intake: Text; Address: Text; PhoneNo: Text)
    var
        AdmH: Record "Admission Form Header";
        AdmNumber: Record "Admissions Number Setup";
    begin
        If AdmNumber.Get(Programme) then
            AdmNumber.TestField("No. Series")
        else
            error('Admission Nos setup has yet to be done');

        AdmH.Init();
        if AdmH."Admission No." = '' then begin
            NoSeriesMgt.GetNextNo(AdmNumber."No. Series");
            //Felix-masila
            //NoSeriesMgt.GetNextNo(AdmNumber."No. Series", AdmNumber."No. Series", 0D, AdmH."Admission No.", AdmNumber."No. Series");
        end;
        AdmH.Surname := Surname;
        AdmH."Other Names" := Names;
        AdmH."Degree Admitted To" := Programme;
        AdmH."Date Of Birth" := DOB;
        AdmH.Gender := Gender;
        AdmH."E-Mail" := Email;
        AdmH.Region := Region;
        AdmH."Intake Code" := Intake;
        AdmH."Correspondence Address 1" := Address;
        AdmH."Telephone No. 1" := PhoneNo;
        AdmH.Insert;
    end;

    procedure InsertOnlineApplicants(IDNumber: Text; Email: Text; Surname: Text; OtherNames: Text; Password: Text; DOB: Date; Gender: Option)
    begin
        onlineAppUser.Init();
        onlineAppUser."ID Number" := IDNumber;
        onlineAppUser.Email := Email;
        onlineAppUser."Date of Birth" := DOB;
        onlineAppUser.Password := Password;
        onlineAppUser."Created Date" := Today;
        onlineAppUser.SurName := Surname;
        onlineAppUser."Other Names" := OtherNames;
        onlineAppUser.Gender := Gender;
        onlineAppUser.Insert();
    end;

    procedure UpdateApplicantInformation(IDNumber: Text; PostalAddress: Text; Postalcode: Text; City: Text; Region: Text; HomePhoneNumber: Text; CellularPhoneNumber: Text)
    begin
        onlineAppUser.Reset();
        onlineAppUser.SetRange("ID Number", IDNumber);
        if onlineAppUser.Find('-') then begin
            onlineAppUser."Postal Address" := PostalAddress;
            onlineAppUser."Postal code" := Postalcode;
            onlineAppUser.City := City;
            onlineAppUser.Region := Region;
            onlineAppUser."Home Phone Number" := HomePhoneNumber;
            onlineAppUser."Cellular Phone Number" := CellularPhoneNumber;
            onlineAppUser.Modify();
        end;
    end;




    var
        NoSeriesMgt: Codeunit "No. Series";
        onlineAppUser: Record "Online Application Users";
}