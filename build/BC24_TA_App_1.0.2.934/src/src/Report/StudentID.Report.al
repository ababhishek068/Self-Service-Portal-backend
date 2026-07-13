Report 50048 "Student ID"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/StudentID.rdlc';
    ApplicationArea = All;

    dataset
    {
        dataitem(Customer; Customer)
        {
            DataItemTableView = where("Customer Type" = filter(Student));
            RequestFilterFields = "No.";
            column(ReportForNavId_2; 2) { }
            column(studNo; Customer."No.") { }
            column(StudName; Customer.Name) { }
            column(cardExpiry; Customer."ID Card Expiry Year") { }
            column(Genders; Format(Customer.Gender)) { }
            column(Cust_Picture; Customer.Image) { }
            column(Image; Image) { }
            column(CompInfo_Picture; CompInfo.Picture) { }
            column(progdesc; Prog.Description) { }
            column(ProvostSignature; genset.Picture) { }
            column(Logo; genset."Bar Code") { }
            column(Contacts1; CompInfo.Address + '-' + CompInfo."Post Code" + ', ' + CompInfo.City + '. Tel: ' + CompInfo."Phone No.") { }
            column(RegDate; Customer."Date Registered") { }
            column(BarcodeNo; Customer."Barcode No") { }

            column(BarcodePic; Customer."Barcode Picture") { }
            column(Nationality; Nationality) { }
            column(ID_No; "ID No") { }
            column(ProgName; ProgName) { }
            column(ExpDate; ExpDate) { }
            trigger OnPreDataItem()
            begin
                CompInfo.get;
                CompInfo.CalcFields(Picture);
            end;

            trigger OnAfterGetRecord()
            var
                ExpFile: text[200];
            begin

                CalcFields(Customer."Barcode Picture");
                // CalcFields(Customer."Student Signature");

                TestField("Current Programme");

                Prog.Get(Customer."Current Programme");
                if Customer.Image.HasValue then begin
                    ExpFile := 'C:\Stud.jpg';
                    Customer.Image.ExportFile(ExpFile);
                    //   Customer.Image.Import(ExpFile);
                end;
                genset.Reset;
                if genset.Find('-') then begin
                    genset.CalcFields(genset.Picture);
                    genset.CalcFields(genset."Bar Code");
                end;
                ProgName := '';
                ExpDate := 0D;
                if prog.get("Current Programme") then
                    ProgName := Prog.Description;
                if Prog.Category = prog.Category::Undergraduate then
                    ExpDate := "Date Registered" + 365 * 4;
                if Prog.Category = prog.Category::Diploma then
                    ExpDate := "Date Registered" + 365 * 2;
                if Prog.Category = prog.Category::Masters then
                    ExpDate := "Date Registered" + 365 * 2;
                if Prog.Category = prog.Category::PHD then
                    ExpDate := "Date Registered" + 365 * 2;
                if Prog.Category = prog.Category::"Certificate " then
                    ExpDate := "Date Registered" + 365 * 2;

            end;
        }
    }

    requestpage
    {

        layout { }

        actions { }
    }

    labels { }

    trigger OnPreReport()
    begin
        CompInfo.Get;
        CompInfo.CalcFields(CompInfo.Picture);
        CompInfo.CalcFields(Picture);
    end;

    var
        Prog: Record Programme;
        ProgName: Text[200];
        ExpDate: date;
        CompInfo: Record "Company Information";
        genset: Record "General Set-Up";
    // recTempBlob: Record TempBlob temporary;
}

