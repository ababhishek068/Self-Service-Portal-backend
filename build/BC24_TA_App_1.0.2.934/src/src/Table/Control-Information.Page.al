Page 52202813 "Control-Information"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Control-Information";
    ApplicationArea = Basic, Suite;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Address; Rec.Address)
                {
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field(Address2; Rec."Address 2")
                {
                    ToolTip = 'Specifies the value of the Address 2 field.';
                }
                field(PostCodeCity; Rec."Post Code")
                {
                    Caption = 'Post Code/City';
                    ToolTip = 'Specifies the value of the Post Code/City field.';
                }
                field(City; Rec.City)
                {
                    ToolTip = 'Specifies the value of the City field.';
                }
                field(PhoneNo; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. field.';
                }
                field(VATRegistrationNo; Rec."VAT Registration No.")
                {
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
                }
                field(CompanyPIN; Rec."Company P.I.N")
                {
                    ToolTip = 'Specifies the value of the Company P.I.N field.';
                }
                field(NSSFNo; Rec."N.S.S.F No.")
                {
                    ToolTip = 'Specifies the value of the N.S.S.F No. field.';
                }
                field(NHIFNo; Rec."N.H.I.F No")
                {
                    ToolTip = 'Specifies the value of the N.H.I.F No field.';
                }
                field(Companycode; Rec."Company code")
                {
                    ToolTip = 'Specifies the value of the Company code field.';
                }
                field(Mission; Rec.Mission)
                {
                    ToolTip = 'Specifies the value of the Mission field.';
                }
                field(Vision; Rec.Vision)
                {
                    ToolTip = 'Specifies the value of the Vision field.';
                }
                field(MissionVisionLink; Rec."Mission/Vision Link")
                {
                    ToolTip = 'Specifies the value of the Mission/Vision Link field.';
                }
                field(PayslipMessage; Rec."Payslip Message")
                {
                    ToolTip = 'Specifies the value of the Payslip Message field.';
                }
                field(Picture; Rec.Picture)
                {
                    ToolTip = 'Specifies the value of the Picture field.';
                }
                field(MultiplePayroll; Rec."Multiple Payroll")
                {
                    ToolTip = 'Specifies the value of the Multiple Payroll field.';
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field("Phone No.1"; Rec."Phone No.")
                {
                    ToolTip = 'Specifies the value of the Phone No. field.';
                }
                field(FaxNo; Rec."Fax No.")
                {
                    ToolTip = 'Specifies the value of the Fax No. field.';
                }
                field(EMail; Rec."E-Mail")
                {
                    ToolTip = 'Specifies the value of the E-Mail field.';
                }
                field(HomePage; Rec."Home Page")
                {
                    ToolTip = 'Specifies the value of the Home Page field.';
                }
            }
            group(PhysicalAddress)
            {
                Caption = 'Physical Address';
                field(ShiptoName; Rec."Ship-to Name")
                {
                    Caption = 'Name';
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(ShiptoAddress; Rec."Ship-to Address")
                {
                    Caption = 'Address';
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field(ShiptoAddress2; Rec."Ship-to Address 2")
                {
                    Caption = 'Address 2';
                    ToolTip = 'Specifies the value of the Address 2 field.';
                }
                field(ShiptoPostCode; Rec."Ship-to Post Code")
                {
                    Caption = 'Post Code/City';
                    ToolTip = 'Specifies the value of the Post Code/City field.';
                }
                field(ShiptoCity; Rec."Ship-to City")
                {
                    ToolTip = 'Specifies the value of the Ship-to City field.';
                }
                field(Contact; Rec."Ship-to Contact")
                {
                    Caption = 'Contact';
                    ToolTip = 'Specifies the value of the Contact field.';
                }
                field(LocationCode; Rec."Location Code")
                {
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Company)
            {
                Caption = 'Company';
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
    end;
}
