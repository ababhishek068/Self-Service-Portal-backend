Page 50706 "Questionaire Card"
{
    PageType = Card;
    SourceTable = "CompanyInfo Questionaire";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("TIN No"; Rec."TIN No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PIN No. field.';
                }
                field(LegalNameofFirm; Rec."Legal Name of Firm")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Legal Name of Firm field.';
                }
                field(PostOfficeBoxNumber; Rec."Post Office Box Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Post Office Box Number field.';
                }
                field(PostCode; Rec."Post Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Post Code field.';
                }
                field(CityTown; Rec.City_Town)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the City_Town field.';
                }
                field(Country; Rec.Country)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Country field.';
                }
                field(PhysicalLocation; Rec."Physical Location")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Physical Location field.';
                }
                field(CityTown2; Rec."City_Town 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the City_Town 2 field.';
                }
                field(Country2; Rec."Country 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Country 2 field.';
                }
                field(Street; Rec.Street)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Street field.';
                }
                field(PlotNo; Rec."Plot No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Plot No field.';
                }
                field(BuildingName; Rec."Building Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Building Name field.';
                }
                field(TelephoneNo; Rec."Telephone No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Telephone No field.';
                }
                field(FaxNumber; Rec."Fax Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Fax Number field.';
                }
                field(MobileNumber; Rec."Mobile Number")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mobile Number field.';
                }
                field(OutOfHoursTelephone; Rec."Out Of Hours Telephone")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Out Of Hours Telephone field.';
                }
                field(EmailAddress; Rec."Email Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Email Address field.';
                }
                field(PersonOfContact; Rec."Person Of Contact")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Person Of Contact field.';
                }
                field(Title; Rec.Title)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Title field.';
                }
            }
            part(Control78; "Bank List")
            {
                SubPageLink = "TIN No." = field("TIN No.");
            }
            part(Control79; "Partnership List")
            {
                SubPageLink = "TIN No." = field("TIN No.");
            }
            part(Control80; "Business Referees List")
            {
                SubPageLink = "TIN No." = field("TIN No.");
            }
            group("Company Info")
            {
                field(CurrentTradeLicenceNo; Rec."Current Trade Licence No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Current Trade Licence No field.';
                }
                field(ExpiryDate; Rec."Expiry Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Expiry Date field.';
                }
                field(MaximumBusinessValue; Rec."Maximum Business Value")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Maximum Business Value field.';
                }
                field(CompanyDirectors; Rec."Company Directors")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Company Directors field.';
                }
                field(CompanySecretary; Rec."Company Secretary")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Company Secretary field.';
                }
                field(GeneralManager; Rec."General Manager")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the General Manager field.';
                }
                field(FinanceManager; Rec."Finance Manager")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Finance Manager field.';
                }
                field(CompanyPharmacist; Rec."Company Pharmacist")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Company Pharmacist field.';
                }
                field(RegNo; Rec."Reg. No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Reg. No. field.';
                }
                field(ManagementPersonnelOthers; Rec."Management Personnel Others")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Management Personnel Others field.';
                }
                field(SoleProprietorName; Rec."Sole Proprietor Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sole Proprietor Name field.';
                }
                field(SoleProprietorNationality; Rec."Sole Proprietor Nationality")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sole Proprietor Nationality field.';
                }
                field(DateOfStart; Rec."Date Of Start")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date Of Start field.';
                }
                field(UnderManagementSince; Rec."Under Management Since")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Under Management Since field.';
                }
                field(NetWorth; Rec."Net Worth")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Net Worth field.';
                }
                field(BankReference; Rec."Bank Reference")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bank Reference field.';
                }
                field(BondingCompany; Rec."Bonding Company")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Bonding Company field.';
                }
                field(MainActivityFieldsSummary; Rec."Main Activity Fields Summary")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Main Activity Fields Summary field.';
                }
                field(SupName; Rec."Sup Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sup Name field.';
                }
                field(SupAddress; Rec."Sup Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sup Address field.';
                }
                field(SupTelephone; Rec."Sup Telephone")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sup Telephone field.';
                }
                field(SupFax; Rec."Sup Fax")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sup Fax field.';
                }
                field(SupEmailAddress; Rec."Sup Email Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sup Email Address field.';
                }
                field(SupCellPhoneNo; Rec."Sup Cell Phone No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sup Cell Phone No field.';
                }
                field(SupEducationQualification; Rec."Sup Education Qualification")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sup Education Qualification field.';
                }
                field(SupRegistrationCerificateNo; Rec."Sup Registration Cerificate No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sup Registration Cerificate No field.';
                }
                field(SupDate; Rec."Sup Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sup Date field.';
                }
                field(SupShareHolderEmployee; Rec."Sup Share Holder_Employee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sup Share Holder_Employee field.';
                }
                field(SupLengthOfService; Rec."Sup Length Of Service")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sup Length Of Service field.';
                }
                field(SupPositionHeld; Rec."Sup Position Held")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Sup Position Held field.';
                }
                field(FPLiabilities; Rec."FP Liabilities")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the FP Liabilities field.';
                }
                field(FPAssetsLiabilitiesDate; Rec."FP Assets_Liabilities Date")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the FP Assets_Liabilities Date field.';
                }
                field(FPAssetsLiabilitiesSummary; Rec."FP Assets_Liabilities Summary")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the FP Assets_Liabilities Summary field.';
                }
                field(FPAssets; Rec."FP Assets")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the FP Assets field.';
                }
                field(FPCashHand; Rec."FP Cash Hand")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the FP Cash Hand field.';
                }
                field(FPCashBank; Rec."FP Cash Bank")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the FP Cash Bank field.';
                }
                field(DeliveryLogistics; Rec."Delivery Logistics")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Delivery Logistics field.';
                }
                field(LeadTimeDelivery; Rec."Lead Time Delivery")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Lead Time Delivery field.';
                }
                field(NatureOfBusiness; Rec."Nature Of Business")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Nature Of Business field.';
                }
                field(CompanyName; Rec."Company Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Company Name field.';
                }
                field(SignedByNames; Rec.Signed_By_Names)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Signed_By_Names field.';
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Date field.';
                }
                field(JobTitlePosition; Rec."Job Title_Position")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Job Title_Position field.';
                }
            }
            group(Communication)
            {
                field(CertUndWe; Rec."Cert Und We")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cert Und We field.';
                }
                field(CertUndTenderer; Rec."Cert Und Tenderer")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cert Und Tenderer field.';
                }
                field(CertUndAddress; Rec."Cert Und Address")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cert Und Address field.';
                }
                field(CertUndTelephone; Rec."Cert Und Telephone")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cert Und Telephone field.';
                }
                field(CertUndFax; Rec."Cert Und Fax")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cert Und Fax field.';
                }
                field(CertUndEmail; Rec."Cert Und Email")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cert Und Email field.';
                }
                field(CertUndMobile; Rec."Cert Und Mobile")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cert Und Mobile field.';
                }
                field(CertUndWitness; Rec."Cert Und Witness")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cert Und Witness field.';
                }
                field(CertUndAddress2; Rec."Cert Und Address 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cert Und Address 2 field.';
                }
                field(CertUndTelephone2; Rec."Cert Und Telephone 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cert Und Telephone 2 field.';
                }
                field(CertUndFax2; Rec."Cert Und Fax 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Cert Und Fax 2 field.';
                }
            }
            group("Bank Details")
            {
                field(BDAccountNo; Rec."BD Account No")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the BD Account No field.';
                }
                field(BDAccountName; Rec."BD Account Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the BD Account Name field.';
                }
                field(BDBankName; Rec."BD Bank Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the BD Bank Name field.';
                }
                field(BDBankCode; Rec."BD Bank Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the BD Bank Code field.';
                }
                field(BDBranchName; Rec."BD Branch Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the BD Branch Name field.';
                }
                field(BDBranchCode; Rec."BD Branch Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the BD Branch Code field.';
                }
                field(MyRecId; Rec.MyRecId)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the MyRecId field.';
                }
                field(TOTOHowDoSuppliersContribute; Rec."TOTO HowDoSuppliersContribute")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the TOTO HowDoSuppliersContribute field.';
                }
            }
        }
    }

    actions { }
}

