Page 50898 "Responsibility Center Card BR"
{
    Caption = 'Responsibility Center Card';
    PageType = Card;
    SourceTable = "Responsibility Center BR";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Code field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field(Address2; Rec."Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Address 2 field.';
                }
                field(PostCodeCity; Rec."Post Code")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Code/City';
                    ToolTip = 'Specifies the value of the Post Code/City field.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the City field.';
                }
                field(CountryRegionCode; Rec."Country/Region Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Country/Region Code field.';
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Contact field.';
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 1 Code field.';
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Global Dimension 2 Code field.';
                }
                field(HODUserID; Rec."HOD User ID")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the HOD User ID field.';
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
            }
            group(Communication)
            {
                Caption = 'Communication';
                field(PhoneNo; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Phone No. field.';
                }
                field(FaxNo; Rec."Fax No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Fax No. field.';
                }
                field(EMail; Rec."E-Mail")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the E-Mail field.';
                }
                field(HomePage; Rec."Home Page")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Home Page field.';
                }
                field(NotifyPaymentUsers; Rec."Notify Payment User(s)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Notify Payment User(s) field.';
                }
                field(PaymentUsersEMail; Rec."Payment User(s) - E-Mail")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the E-Mail field.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(RespCtr)
            {
                Caption = '&Resp. Ctr.';
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = const(39006016),
                                  "No." = field(Code);
                    ShortCutKey = 'Shift+Ctrl+D';
                    Visible = false;
                    ToolTip = 'Executes the Dimensions action.';
                }
            }
        }
    }
}

