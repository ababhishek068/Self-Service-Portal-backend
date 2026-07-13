Page 51287 "PR Rates & Ceilings"
{
    PageType = Card;
    SourceTable = "PR Vital Setup Info";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(TaxRelief)
            {
                Caption = 'Tax Relief';
                field(SetupCode; Rec."Setup Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Specifies the value of the Setup Code field.';
                }
                field(Control20; Rec."Tax Relief")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tax Relief field.';
                }
                field("House Allowance Percentage"; "House Allowance Percentage") { }
                field("Transport Allowance Percentage";"Transport Allowance Percentage"){}
                field("Managerial Fuel litres"; "Managerial Fuel litres") { }
                field("Non-Managerial Fuel litres"; "Non-Managerial Fuel litres") { }
                field("Fuel Rate"; "Fuel Rate") { }
                field("Defined Maximum Transport Allowance-Gov"; "Defined Maximum Fuel Allowance") { }
                field("Working in Office Transport Amount";"Working in Office Tra"){}
                field("Out of Office Max Allowance";"Out of Office Max Allowance"){}
                field("Transport Allowance Percentage from basic";"Transport Allowance Percentage"){}
                field(InsuranceRelief; Rec."Insurance Relief")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Insurance Relief field.';
                }
                field(MinimumReliefAmount; Rec."Minimum Relief Amount")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minimum Relief Amount field.';
                }
                field(MaxRelief; Rec."Max Relief")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Relief field.';
                }
                field(DisbledTaxLimit; Rec."Disbled Tax Limit")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Disbled Tax Limit field.';
                }
                field(MinimumTaxablePay; Rec."Minimum Taxable Pay")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Minimum Taxable Pay field.';
                }
                //field("% Staff Claim";"% Staff Claim"){}
            }
            group(medical)
            {
                Caption='Medical setups';
                
                field("Medical Refund percentage-Self";rec."Medical Refund percentage-Self"){
                    ApplicationArea=basic;
                    
                }
                field("Medical Refund percentage-kin";rec."Medical Refund percentage-dependant"){
                    ApplicationArea=basic;
                }
            }
            group(PensionContribution)
            {
                Caption = 'Pension Contribution';
                field(PensionEmployee; Rec."Pension Employee")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pension Employee field.';
                }
                field(PensionEmployerFactor; Rec."Pension Employer Factor")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pension Employer Factor field.';
                }
                field(PensionBasedon; Rec."Pension Based on")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pension Based on field.';
                }
                field("Cost share percentage"; "Cost share percentage") { }
                field(ImplementNewPension; Rec."Implement New Pension")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Implement New Pension field.';
                    Visible=false;
                }
                //field("Working in Office Tra";"Working in Office Tra"){}
                //field("Out of Office Max Allowance";"Out of Office Max Allowance"){}
                field("Social ContributioCode";"Social ContributioCode"){}
                field("Social Cont Registation Amount";"Social Cont Registation Amount"){}
                field("Social Contriution Perc";"Social Contriution Perc"){}
                field("Overtime Code"; "Overtime Code") { }
                field("Claims Code"; "Claims Code") { }
                field("% Staff Claim"; "% Staff Claim") { }
                field("% GlasFrames"; "% GlasFrames") { }
                field("Minimum take home"; "Minimum take home") { }
                field(PensionRate; Rec."Pension Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pension Rate field.';
                }
                field(PensionLowerEarningLimit; Rec."Pension Lower Earning Limit(LEL)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pension Lower Earning Limit(LEL) field.';
                }
                field(PensionUpperEarningLimit; Rec."Pension Upper Earning Limit(UEL)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Pension Upper Earning Limit(UEL) field.';
                }
                // field("House all code";"House all code"){}
                // field("Mobi all code";"Mobi all code"){}
                // field("Position all code";"Position all code"){}
                // field("Fuel all code";"Fuel all code"){}
                // field("Hardship all code";"Hardship all code"){}
                // field("Acting Allowance";"Acting Allowance"){}
                field("Advance Payable Account"; "Advance Payable Account") { }
                field("Advance Deduction code"; "Advance Deduction code") { }
                field("Guarantee Recovery code"; "Guarantee Recovery code") { }
                field("Guarantee Refund code"; "Guarantee Refund code") { }

            }
            group(taxableallowances)
            {
                Caption = 'Taxable Allowances Codes';
                field("House all code"; "House all code") { }
                field("Taxable Trans Allow Code";"Taxable Trans Allow Code"){}
                field("Hardship all code"; "Hardship all code") { }
                field("Position all code"; "Position all code") { }
                field("Fuel all code"; "Fuel all code") { }
                field("Mobi all code"; "Mobi all code") { }
                field("Acting Allowance"; "Acting Allowance") { }
                field("Acting Representation all code"; "Acting Representation all code") { }
            }
            group(nontaxableallowances)
            {
                Caption = 'Non-Taxable Allowances Codes';
                field("House all code nontax"; "House all code nontax") { }
                field("NonTaxable Trans Allow Code";"NonTaxable Trans Allow Code"){}
                field("Hardship all code nontax"; "Hardship all code nontax") { }
                field("Position all code nontax"; "Position all code nontax") { }
                field("Fuel all code nontax"; "Fuel all code nontax") { }
                field("Mobi all code Nontax"; "Mobi all code Nontax") { }
                field("Acting Allowance nontax"; "Acting Allowance nontax") { }
                field("Acting Representation all nontax"; "Acting Representation all nontax") { }
            }
            group(NHIF)
            {
                Caption = 'NHIF';
                field(Selectone; Rec."NHIF Based on")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the NHIF Based on field.';
                    //  Caption = 'Select one:';
                }

                field("Implement NHIF Relief"; Rec."Implement NHIF Relief")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Implement NHIF Relief field.';
                }

                field("NHIF NHIF Relief Percentage"; Rec."NHIF Relief Percentage")
                {

                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the NHIF Relief Percentage field.';

                }
                field("Enable Relief On PAYE Only"; Rec."Enable Relief On PAYE Only")
                {
                    ApplicationArea = basic;
                    ToolTip = 'Specifies the value of the Enable Relief On PAYE Only field.';

                }
            }
            group(Pension)
            {
                Caption = 'Pension';
                field(MaxPensionContribution; Rec."Max Pension Contribution")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Max Pension Contribution field.';
                }
                field(TaxOnExcessPension; Rec."Tax On Excess Pension")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Tax On Excess Pension field.';
                }
                field("PrPension Employer Code"; Rec."PrPension Employer Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PrPension Employer Code field.';
                }
                field("PrPension Employee Code"; Rec."PrPension Employee Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PrPension Employee Code field.';
                }
            }
            group(Mortgage)
            {
                Caption = 'Mortgage';
                field(MortgageReliefLessfromTaxablePay; Rec."Mortgage Relief")
                {
                    ApplicationArea = Basic;
                    Caption = 'Mortgage Relief (Less from Taxable Pay)';
                    ToolTip = 'Specifies the value of the Mortgage Relief (Less from Taxable Pay) field.';
                }
                field(MortgageReliefPercentage; Rec."Mortgage Relief Percentage")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Mortgage Relief Percentage field.';
                }
            }
            group(OwnerOccupierInterest)
            {
                Caption = 'Owner Occupier Interest';
                field(MaxMonthlyContribution; Rec."OOI Deduction")
                {
                    ApplicationArea = Basic;
                    Caption = 'Max Monthly Contribution';
                    ToolTip = 'Specifies the value of the Max Monthly Contribution field.';
                }
                field(Decemberdeduction; Rec."OOI December")
                {
                    ApplicationArea = Basic;
                    Caption = 'December deduction';
                    ToolTip = 'Specifies the value of the December deduction field.';
                }
            }
            group(StaffLoans)
            {
                Caption = 'Staff Loans';
                field(LoanMarketRate; Rec."Loan Market Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Loan Market Rate field.';
                }
                field(LoanCorporateRate; Rec."Loan Corporate Rate")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Loan Corporate Rate field.';
                }
            }
            group(PayslipMessage)
            {
                Caption = 'Payslip Message';
                field(Control27; Rec."Payslip Message")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Payslip Message field.';
                }
                field(PWDStaffRetirementAge; Rec."PWD Staff Retirement Age")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the PWD Staff Retirement Age field.';
                }
                field(OtherStaffRetirementAge; Rec."Other Staff Retirement Age")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Other Staff Retirement Age field.';
                }
            }

            group(PayrollProration)
            {
                Caption = 'Payroll Proration';
                field("Enable Payroll Proration"; Rec."Enable Payroll Proration")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the value of the Enable Payroll Proration field.';
                }
            }
        }
    }
}
