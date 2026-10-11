import type { DetailFieldConfig } from '@/components/shared/RequestFormPage'
import { financeOrgDetailFields } from '@/data/financeOrgDetailFields'

/**
 * Header fields shown to APPROVERS on the approval detail screen, per module.
 *
 * UAT fail C: fuel (and other header-only documents) reached the approver with
 * no request details at all — the approval screen only rendered lines, and
 * fuel has none. These mirror the requester-side detail fields of each module
 * page, resolved against the same `payload` (raw Business Central row).
 */
export const approvalDetailFields: Record<string, DetailFieldConfig[]> = {
  leave: [
    {
      label: 'Leave Type',
      paths: [
        'payload.LeaveTypeDescription',
        'payload.Leave_Type_Description',
        'payload.leaveTypeDescription',
      ],
    },
    {
      label: 'Days Requested',
      paths: ['payload.DaysApplied', 'payload.Days_Applied', 'request.amount'],
    },
    {
      label: 'Start Date',
      paths: ['payload.StartDate', 'payload.Start_Date'],
      format: 'date',
    },
    {
      label: 'End Date',
      paths: ['payload.EndDate', 'payload.End_Date'],
      format: 'date',
    },
    {
      label: 'Return Date',
      paths: [
        'payload.ReturnDate',
        'payload.Return_Date',
        'payload.ExpectedReturnDate',
        'payload.Expected_Return_Date',
      ],
      format: 'date',
    },
    {
      label: 'Reliever',
      paths: ['payload.RelieverName', 'payload.Reliever_Name', 'payload.Reliever'],
    },
    {
      label: 'Department',
      paths: [
        'request.departmentName',
        'payload.DepartmentName',
        'payload.Department_Name',
        'request.departmentCode',
        'payload.Department',
      ],
    },
  ],
  fuelRequest: [
    { label: 'Request Type', paths: ['payload.RequisitionType', 'payload.Requisition_Type', 'payload.RequestType', 'payload.Request_Type'] },
    { label: 'Fuel Card No.', paths: ['payload.FuelCardNo', 'payload.Fuel_Card_No', 'payload.CardNo', 'payload.Card_No'] },
    { label: 'Vehicle No.', paths: ['payload.VehicleRegNo', 'payload.Vehicle_Reg_No', 'payload.VehicleNo', 'payload.Vehicle_No'] },
    { label: 'Fuel Dealer', paths: ['payload.VendorDealer', 'payload.Vendor_Dealer', 'payload.FuelDealer', 'payload.Fuel_Dealer'] },
    { label: 'Dealer Name', paths: ['payload.VendorName', 'payload.Vendor_Name'] },
    { label: 'Quantity (Litres)', paths: ['payload.QuantityofFuelLitres', 'payload.Quantity_of_Fuel_Litres', 'payload.Quantity'] },
    {
      label: 'Previous KM',
      paths: ['payload.VehicleCurrentReading', 'payload.Vehicle_Current_Reading'],
    },
    {
      label: 'Current KM',
      paths: ['payload.CurrentOdometer', 'payload.Initial_Odometer_Reading', 'payload.InitialOdometerReading'],
    },
    { label: 'Vehicle Fuel Rating (km/L)', paths: ['payload.VehicleFuelRating'] },
    { label: 'Price per Litre', paths: ['payload.PriceLitre', 'payload.Price_Litre', 'payload.Price'], format: 'currency' },
    { label: 'Total Fuel Price', paths: ['payload.TotalPriceofFuel', 'payload.Total_Price_of_Fuel', 'request.amount'], format: 'currency' },
    { label: 'Request Date', paths: ['payload.RequestDate', 'payload.Request_Date'], format: 'date' },
    { label: 'Purpose', paths: ['payload.Description', 'payload.Purpose'] },
    { label: 'Consumption Remark', paths: ['payload.consumptionRemark', 'payload.ConsumptionRemark', 'payload.IssueDescription'] },
  ],
  maintenance: [
    { label: 'Request Type', paths: ['payload.maintenanceRequestTypeLabel', 'payload.RequestType', 'payload.RequisitionType', 'payload.Requisition_Type', 'payload.Type'] },
    { label: 'Vehicle No.', paths: ['payload.VehicleNo', 'payload.VehicleRegNo', 'payload.Vehicle_Reg_No'] },
    { label: 'Fixed Asset', paths: ['payload.FATagNumber', 'payload.FixedAssetNo', 'payload.Fixed_Asset_No'] },
    { label: 'Type of Maintenance', paths: ['payload.TypeofMaintenance', 'payload.Type_of_Maintenance'] },
    { label: 'Request Date', paths: ['payload.RequestDate', 'payload.Request_Date'], format: 'date' },
    { label: 'Item / Service', paths: ['payload.Item'] },
    { label: 'Quantity', paths: ['payload.Quantity'], hideZero: true },
    { label: 'Priority', paths: ['payload.Priority'] },
    { label: 'Location', paths: ['payload.Location'] },
    {
      label: 'Current Odometer',
      paths: ['payload.CurrentOdometer', 'payload.Odometer'],
      format: 'km',
      hideZero: true,
    },
    {
      label: 'Last Service Odometer',
      paths: ['payload.LastServiceOdometer', 'payload.Last_Service_Odometer'],
      format: 'km',
      hideZero: true,
    },
    {
      label: 'Next Service KM',
      paths: ['payload.NextServiceKM', 'payload.Next_Service_KM', 'payload.NextMaintenanceKM'],
      format: 'km',
      hideZero: true,
    },
    { label: 'Assigned Technician', paths: ['payload.AssignedTechnicianName', 'payload.AssignedTechnician'] },
    { label: 'Receipt Confirmed On', paths: ['payload.FAReceivedDate'], format: 'date' },
    { label: 'Receipt Remarks', paths: ['payload.ReceiptRemarks'] },
    { label: 'Description', paths: ['payload.IssueDescription', 'payload.MaintenanceDescription', 'payload.Description'] },
  ],
  transport: [
    { label: 'Request Type', paths: ['payload.transportRequestTypeLabel', 'payload.RequestType', 'payload.Request_Type', 'payload.VehicleType', 'payload.Vehicle_Type'] },
    { label: 'Vehicle Allocated', paths: ['payload.Vehicle_Allocated', 'payload.VehicleAllocated'] },
    { label: 'Trip Origin / Starting From', paths: ['payload.Commencement', 'payload.CommenceFrom', 'payload.StartingFrom'] },
    { label: 'Destination', paths: ['payload.To', 'payload.Destination'] },
    { label: 'Date of Trip', paths: ['payload.Date_of_Trip', 'payload.DateOfTrip'], format: 'date' },
    { label: 'Responsibility Center', paths: ['payload.Responsibility_Center', 'payload.ResponsibilityCenter', 'request.responsibleCenter'] },
    { label: 'No. of Days', paths: ['payload.No_of_Days_Requested', 'payload.NoOfDays'] },
    { label: 'No. of Passengers', paths: ['payload.No_Of_Passangers', 'payload.NoOfPassengers'] },
    { label: 'Purpose', paths: ['payload.Purpose_of_Trip', 'payload.PurposeOfTrip', 'payload.Purpose'] },
  ],
  training: [
    { label: 'Primary Training Course', paths: ['payload.trainingNeed', 'payload.TrainingCourseCode', 'payload.CourseTitle'] },
    { label: 'Additional Training(s)', paths: ['payload.otherTrainingName', 'payload.additionalTrainingNeeds'] },
    { label: 'Department', paths: ['payload.department', 'payload.DepartmentCode', 'request.departmentName'] },
    { label: 'Purpose / Expected Outcome', paths: ['payload.purpose', 'payload.Purpose'] },
    { label: 'Training Type', paths: ['payload.trainingType', 'payload.TrainingType'] },
    { label: 'Duration (Days)', paths: ['payload.durationDays', 'payload.DurationDays'] },
    { label: 'Target Group', paths: ['payload.targetGroup', 'payload.TargetGroup'] },
    { label: 'No. of Participants', paths: ['payload.participants', 'payload.NoOfParticipants'] },
    { label: 'Quarter', paths: ['payload.quarter', 'payload.Quarter'] },
    { label: 'Priority', paths: ['payload.priority', 'payload.Priority'] },
    { label: 'Vendor / Provider', paths: ['payload.vendor', 'payload.RecommendedVendor'] },
    { label: 'Estimated Budget', paths: ['payload.estimatedBudget', 'payload.EstimatedBudget'], format: 'currency' },
    { label: 'Training Period Start', paths: ['payload.periodStart', 'payload.TrainingStartDate'], format: 'date' },
    { label: 'Training Period End', paths: ['payload.periodEnd', 'payload.TrainingEndDate'], format: 'date' },
    { label: 'Remark', paths: ['payload.remark', 'payload.Remark'] },
  ],
  workTickets: [
    { label: 'Ticket No.', paths: ['request.requestNo', 'payload.TicketNo'] },
    { label: 'Traveler', paths: ['payload.travelerName', 'payload.travelerEmployeeNo'] },
    { label: 'Flight From', paths: ['payload.flightFrom'] },
    { label: 'Flight To', paths: ['payload.flightTo'] },
    { label: 'Departure Date', paths: ['payload.departureDate'], format: 'date' },
    { label: 'Return Date', paths: ['payload.returnDate'], format: 'date' },
    { label: 'Ticket Class', paths: ['payload.ticketClass'] },
    { label: 'Airline Preference', paths: ['payload.airlinePreference'] },
    { label: 'Booking Justification', paths: ['payload.justification'] },
    { label: 'Booking Confirmation No.', paths: ['payload.bookingConfirmationNo'] },
  ],
  purchaseRequisition: [
    { label: 'Requisition No.', paths: ['request.requestNo', 'payload.No'] },
    { label: 'Requested By', paths: ['request.makerName', 'payload.RequestorName', 'payload.RequesterName', 'payload.AssignedUserID'] },
    { label: 'Employee No.', paths: ['request.makerEmployeeNo', 'payload.EmployeeNo', 'payload.Employee_No_'] },
    {
      label: 'Needed By Date',
      paths: [
        'payload.Needed_By_Date',
        'payload.OrderDate',
        'payload.Order_Date',
        'payload.RequestedReceiptDate',
        'payload.Requested_Receipt_Date',
      ],
      format: 'date',
    },
    {
      label: 'Request Date',
      paths: ['payload.DocumentDate', 'payload.Document_Date', 'request.createdAt', 'payload.SystemCreatedAt'],
      format: 'date',
    },
    {
      label: 'Location',
      paths: [
        'payload.LocationCode',
        'payload.Location_Code',
        'payload.lines.0.LocationCode',
        'payload.lines.0.Location_Code',
        'payload.lines.0.location',
      ],
    },
    {
      label: 'Description',
      paths: ['payload.Posting_Description', 'payload.PostingDescription', 'payload.RequestDescription'],
    },
    {
      label: 'Requesting Department',
      paths: [
        'payload.Department',
        'payload.RequestingDepartment',
        'payload.Requesting_Department',
        'payload.Shortcut_Dimension_1_Code',
        'request.departmentName',
        'request.departmentCode',
      ],
    },
    {
      label: 'Department / Cost Centre',
      paths: [
        'request.departmentName',
        'request.departmentCode',
        'payload.ShortcutDimension2Code',
        'payload.Shortcut_Dimension_2_Code',
      ],
    },
    {
      label: 'Division',
      paths: ['payload.GlobalDimension1Code', 'payload.Global_Dimension_1_Code', 'payload.ShortcutDimension1Code'],
    },
    {
      label: 'Responsibility Centre',
      paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter', 'payload.Responsibility_Center'],
    },
    {
      label: 'Total Value',
      paths: [
        'payload.AmountIncludingVAT',
        'payload.Amount_Including_VAT',
        'payload.Amount',
        'payload.CommittedAmount',
        'request.amount',
      ],
      format: 'currency',
    },
    { label: 'Status', paths: ['request.status'], format: 'status' },
  ],
  storeRequisition: [
    { label: 'Requisition No.', paths: ['request.requestNo', 'payload.No'] },
    { label: 'Requested By', paths: ['request.makerName', 'payload.RequesterName', 'payload.RequesterID'] },
    { label: 'Employee No.', paths: ['request.makerEmployeeNo', 'payload.EmployeeNo'] },
    { label: 'Job Title', paths: ['payload.RequesterJobTitle'] },
    { label: 'Branch / Place of Duty', paths: ['payload.RequesterPlaceOfDuty', 'payload.RequesterBranch'] },
    { label: 'Request Date', paths: ['payload.Requestdate', 'payload.RequestDate', 'request.createdAt'], format: 'date' },
    { label: 'Date Required', paths: ['payload.RequiredDate', 'payload.Required_Date', 'payload.RequestDate'], format: 'date' },
    { label: 'Issuing Store', paths: ['payload.IssuingStore', 'payload.Issuing_Store'] },
    { label: 'Description', paths: ['payload.RequestDescription', 'payload.Request_Description'] },
    { label: 'Justification', paths: ['payload.Justification'] },
    { label: 'Department / Cost Centre', paths: ['request.departmentName', 'request.departmentCode', 'payload.ShortcutDimension2Code'] },
    { label: 'Division', paths: ['payload.GlobalDimension1Code', 'payload.Global_Dimension_1_Code'] },
    { label: 'Responsibility Centre', paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter'] },
    { label: 'Store Receipt No.', paths: ['payload.SRNNo', 'payload.SRN_No'] },
    { label: 'Issue Date', paths: ['payload.IssueDate', 'payload.Issue_Date'], format: 'date' },
    { label: 'Total Value', paths: ['payload.TotalAmount', 'request.amount'], format: 'currency' },
    { label: 'Status', paths: ['request.status'], format: 'status' },
  ],
  gatePass: [
    { label: 'Source', paths: ['payload.gatePassSourceLabel', 'payload.Linkto', 'payload.Link_to'] },
    { label: 'Source Document No.', paths: ['payload.TransferNo', 'payload.Transfer_No', 'payload.AssetTransferNo'] },
    { label: 'From Location', paths: ['payload.FromLocation', 'payload.From_Location', 'payload.AssetFromLocation'] },
    { label: 'To Location', paths: ['payload.ToLocation', 'payload.To_Location', 'payload.AssetToLocation'] },
    { label: 'Date Out', paths: ['payload.DateOut', 'payload.Date_Out', 'payload.DateCreated'], format: 'date' },
    { label: 'Description', paths: ['payload.Description'] },
    { label: 'Comment', paths: ['payload.Comment'] },
  ],
  transferOrder: [
    { label: 'From', paths: ['payload.TransferFromCode', 'payload.Transfer_from_Code', 'payload.FromCode'] },
    { label: 'To', paths: ['payload.TransferToCode', 'payload.Transfer_to_Code', 'payload.ToCode'] },
    { label: 'In-Transit Code', paths: ['payload.InTransitCode', 'payload.In_Transit_Code'] },
    { label: 'Posting Date', paths: ['payload.PostingDate', 'payload.Posting_Date'], format: 'date' },
    { label: 'Driver', paths: ['payload.DriverName', 'payload.Driver_Name'] },
    { label: 'Truck No.', paths: ['payload.TruckNo', 'payload.Truck_No'] },
  ],
  assetTransfer: [
    { label: 'Transfer Type', paths: ['payload.TransferType', 'payload.Transfer_Type', 'payload.TypeOfTransfer'] },
    {
      label: 'Asset No.',
      paths: [
        'payload.AssetToTransfer',
        'payload.Asset_to_Transfer',
        'payload.AssetNo',
        'payload.Asset_No',
        'payload.FixedAssetNo',
      ],
    },
    {
      label: 'Vehicle Registration No.',
      paths: [
        'payload.VehicleRegistrationNo',
        'payload.Vehicle_Registration_No',
        'payload.RegistrationNo',
        'payload.Registration_No',
      ],
    },
    { label: 'Asset Description', paths: ['payload.AssetDescription', 'payload.VehicleDescription'] },
    { label: 'Tag No.', paths: ['payload.TagNo', 'payload.Tag_No'] },
    {
      label: 'From Employee',
      paths: [
        'payload.FromEmployeeName',
        'payload.FromResponsibleEmployee',
        'payload.From_Responsible_Employee',
        'payload.FromEmployeeNo',
        'payload.From_Employee_No',
      ],
    },
    {
      label: 'To Employee',
      paths: [
        'payload.ToEmployeeName',
        'payload.ToResponsibleEmployee',
        'payload.To_Responsible_Employee',
        'payload.ToEmployeeNo',
        'payload.To_Employee_No',
      ],
    },
    { label: 'From Location', paths: ['payload.FromLocation', 'payload.From_Location'] },
    { label: 'To Location', paths: ['payload.ToLocation', 'payload.To_Location'] },
    { label: 'Reason', paths: ['payload.ReasonText', 'payload.Reason', 'payload.Description'] },
  ],
  imprest: [
    { label: 'Request No.', paths: ['request.requestNo'] },
    {
      label: 'Date Required',
      paths: [
        'payload.DateRequired',
        'payload.Date_Required',
        'payload.PaymentReleaseDate',
        'payload.Date',
        'request.createdAt',
      ],
      format: 'date',
    },
    { label: 'Purpose', paths: ['payload.Purpose', 'payload.purpose'] },
    {
      label: 'Travel Destination',
      paths: ['payload.TravelDestination', 'payload.Travel_Destination', 'payload.Destination'],
    },
    {
      label: 'Duration Date',
      paths: ['payload.DurationDate'],
    },
    {
      label: 'Travel Start Date',
      paths: ['payload.TravelStartDate', 'payload.Travel_Start_Date', 'payload.TravelDate', 'payload.Travel_Date'],
      format: 'date',
    },
    {
      label: 'Expected Return Date',
      paths: ['payload.ExpectedReturnDate', 'payload.Expected_Return_Date', 'payload.ReturnDate', 'payload.Return_Date'],
      format: 'date',
    },
    {
      label: 'Daily Rate (Job Grade)',
      paths: ['payload.DailyRate', 'payload.Daily_Rate', 'payload.DailyRateAmount'],
      format: 'currency',
    },
    {
      label: 'Department',
      paths: [
        'request.departmentName',
        'payload.DepartmentName',
        'payload.Department',
      ],
    },
    ...financeOrgDetailFields.filter((field) => field.label !== 'Department'),
    {
      label: 'Responsibility Center',
      paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter', 'payload.Responsibility_Center'],
    },
    { label: 'Job Title', paths: ['payload.JobTitle', 'payload.Job_Title', 'payload.JobTitleDescription'] },
    {
      label: 'Job Grade',
      paths: ['payload.JobGrade', 'payload.Job_Grade', 'payload.Grade', 'payload.SalaryGrade'],
    },
    { label: 'Place of Duty', paths: ['payload.PlaceofDuty', 'payload.PlaceOfDuty', 'payload.DutyArea'] },
    {
      label: 'Total Net Amount',
      paths: ['payload.TotalNetAmount', 'payload.Total_Net_Amount', 'request.amount'],
      format: 'currency',
    },
    {
      label: 'Remaining Not Settled',
      paths: [
        'payload.RemainingUnsettledAmount',
        'payload.RemainingNotSettledAmount',
        'payload.Balance',
        'payload.OutstandingBalance',
      ],
      format: 'currency',
    },
    {
      label: 'Rejection Reason',
      paths: [
        'payload.RejectionReason',
        'payload.rejectionReason',
        'payload.Comment',
        'payload.Comments',
      ],
    },
  ],
  imprestSurrender: [
    { label: 'Surrender No.', paths: ['request.requestNo'] },
    {
      label: 'Surrender Date',
      paths: ['payload.SurrenderDate', 'payload.Surrender_Date', 'payload.DateCreated', 'request.createdAt'],
      format: 'date',
    },
    { label: 'Imprest No.', paths: ['payload.ImprestIssueDocNo', 'payload.Imprest_Issue_Doc_No', 'payload.ImprestNo'] },
    { label: 'Purpose', paths: ['payload.Purpose', 'request.title'] },
    {
      label: 'Duration Date',
      paths: ['payload.DurationDate'],
    },
    {
      label: 'Travel Start Date',
      paths: ['payload.TravelStartDate', 'payload.Travel_Start_Date', 'payload.TravelDate'],
      format: 'date',
    },
    {
      label: 'Expected Return Date',
      paths: ['payload.ExpectedReturnDate', 'payload.Expected_Return_Date', 'payload.ReturnDate'],
      format: 'date',
    },
    {
      label: 'Actual Return Date',
      paths: ['payload.ActualReturnDate', 'payload.Actual_Return_Date'],
      format: 'date',
    },
    {
      label: 'Travel Destination',
      paths: [
        'payload.TravelDestination',
        'payload.Travel_Destination',
        'payload.Destination',
        'payload.DestinationCode',
      ],
    },
    {
      label: 'Department',
      paths: [
        'request.departmentName',
        'payload.DepartmentName',
        'payload.Department',
      ],
    },
    ...financeOrgDetailFields.filter((field) => field.label !== 'Department'),
    {
      label: 'Responsibility Center',
      paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter'],
    },
    { label: 'Job Title', paths: ['payload.JobTitle', 'payload.Job_Title'] },
    {
      label: 'Job Grade',
      paths: ['payload.JobGrade', 'payload.Job_Grade', 'payload.Grade', 'payload.SalaryGrade'],
    },
    { label: 'Place of Duty', paths: ['payload.PlaceofDuty', 'payload.PlaceOfDuty', 'payload.DutyArea'] },
    {
      label: 'Employee Account No.',
      paths: [
        'payload.EmployeeAccountNo',
        'payload.CustomerNo',
        'payload.AccountNo',
        'payload.Account_No',
        'payload.ImprestNo',
      ],
    },
    {
      label: 'Imprest Amount',
      paths: ['payload.TotalNetAmount', 'payload.Amount', 'request.amount'],
      format: 'currency',
    },
    {
      label: 'Actual Spent (Total)',
      paths: ['payload.TotalActualSpent', 'payload.ActualSpent', 'payload.Actual_Spent'],
      format: 'currency',
    },
    {
      label: 'Remaining Not Settled',
      paths: [
        'payload.RemainingUnsettledAmount',
        'payload.RemainingNotSettledAmount',
        'payload.OutstandingBalance',
        'payload.BalanceLessThisEntry',
        'payload.Balance_Less_This_Entry',
        'payload.Balance',
      ],
      format: 'currency',
    },
    {
      label: 'Cash Surrender Amount',
      paths: [
        'payload.CashSurrenderAmt',
        'payload.Cash_Surrender_Amt',
        'payload.CashSurrenderAmount',
      ],
      format: 'currency',
    },
    {
      label: 'Surrender Status',
      paths: ['payload.SurrenderStatus', 'payload.Surrender_Status'],
    },
    {
      label: 'Rejection Reason',
      paths: [
        'payload.RejectionReason',
        'payload.rejectionReason',
        'payload.Comment',
        'payload.Comments',
      ],
    },
  ],
  pettyCash: [
    { label: 'Request No.', paths: ['request.requestNo'] },
    {
      label: 'Needed By Date',
      paths: ['payload.Needed_By_Date', 'payload.RequiredDate', 'payload.Date', 'request.createdAt'],
      format: 'date',
    },
    { label: 'Description', paths: ['payload.PaymentNarration', 'payload.Payment_Narration', 'payload.Narration'] },
    {
      label: 'Employee No.',
      paths: ['payload.EmployeeNo', 'payload.Employee_No', 'request.makerEmployeeNo'],
    },
    {
      label: 'Payee / Employee Name',
      paths: ['payload.Payee', 'payload.EmployeeName', 'payload.Employee_Name', 'request.makerName'],
    },
    {
      label: 'Employee Account No.',
      paths: ['payload.EmployeeAccountNo', 'payload.CustomerNo', 'payload.AccountNo'],
    },
    {
      label: 'Pay Mode',
      paths: ['payload.PayMode', 'payload.Pay_Mode', 'payload.PaymentMethod'],
    },
    ...financeOrgDetailFields,
    {
      label: 'Responsibility Center',
      paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter'],
    },
    {
      label: 'Job Title',
      paths: ['payload.JobTitle', 'payload.Job_Title', 'payload.JobTitleDescription'],
    },
    {
      label: 'Job Grade',
      paths: ['payload.JobGrade', 'payload.Job_Grade', 'payload.Grade', 'payload.SalaryGrade'],
    },
    {
      label: 'Place of Duty',
      paths: ['payload.PlaceofDuty', 'payload.PlaceOfDuty', 'payload.Place_of_Duty', 'payload.DutyArea'],
    },
    {
      label: 'Total Net Amount',
      paths: ['payload.TotalNetAmount', 'payload.TotalPaymentAmount', 'request.amount'],
      format: 'currency',
    },
    {
      label: 'Rejection Reason',
      paths: ['payload.RejectionReason', 'payload.rejectionReason'],
    },
  ],
  pettyCashReplenishment: [
    { label: 'Request No.', paths: ['request.requestNo'] },
    {
      label: 'Date created',
      paths: ['payload.DateCreated', 'payload.Date_Created', 'request.createdAt'],
      format: 'date',
    },
    {
      label: 'Employee No.',
      paths: ['payload.EmployeeNo', 'payload.Employee_No', 'request.makerEmployeeNo'],
    },
    {
      label: 'Payee / Employee Name',
      paths: ['payload.EmployeeName', 'payload.Employee_Name', 'request.makerName'],
    },
    {
      label: 'Employee Account No.',
      paths: ['payload.EmployeeAccountNo', 'payload.CustomerNo', 'payload.AccountNo'],
    },
    ...financeOrgDetailFields,
    {
      label: 'Responsibility Center',
      paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter'],
    },
    {
      label: 'Job Title',
      paths: ['payload.JobTitle', 'payload.Job_Title', 'payload.JobTitleDescription'],
    },
    {
      label: 'Job Grade',
      paths: ['payload.JobGrade', 'payload.Job_Grade', 'payload.Grade', 'payload.SalaryGrade'],
    },
    {
      label: 'Place of Duty',
      paths: ['payload.PlaceofDuty', 'payload.PlaceOfDuty', 'payload.DutyArea'],
    },
    {
      label: 'Petty Cash Limit',
      paths: ['payload.PettyCashDepartmentLimit'],
      format: 'currency',
    },
    {
      label: 'Limit Source',
      paths: ['payload.PettyCashLimitDepartment', 'payload.PettyCashLimitSource'],
    },
    {
      label: 'Requested amount',
      paths: ['payload.SourceAmount', 'payload.Source_Amount', 'payload.Amount_2', 'request.amount'],
      format: 'currency',
    },
    {
      label: 'Receiving account',
      paths: ['payload.ReceivingAccount', 'payload.Receiving_Account'],
    },
    {
      label: 'Rejection Reason',
      paths: ['payload.RejectionReason', 'payload.rejectionReason'],
    },
  ],
  staffClaim: [
    { label: 'Claim No.', paths: ['request.requestNo'] },
    { label: 'Claim Date', paths: ['payload.ClaimDate', 'payload.Claim_Date', 'request.createdAt'], format: 'date' },
    { label: 'Purpose', paths: ['payload.ClaimDescription', 'payload.Claim_Description', 'payload.Purpose'] },
    {
      label: 'Per Diem Duration',
      paths: ['payload.DurationDate'],
    },
    {
      label: 'Per Diem Start Date',
      paths: ['payload.ExpenditureStartDate', 'payload.TravelDate'],
      format: 'date',
    },
    {
      label: 'Per Diem End Date',
      paths: ['payload.ExpenditureEndDate', 'payload.ReturnDate'],
      format: 'date',
    },
    {
      label: 'Employee Account No.',
      paths: ['payload.EmployeeAccountNo', 'payload.CustomerNo', 'payload.AccountNo', 'payload.Account_No'],
    },
    {
      label: 'Department',
      paths: [
        'request.departmentName',
        'payload.DepartmentName',
        'payload.Department',
      ],
    },
    ...financeOrgDetailFields.filter((field) => field.label !== 'Department'),
    {
      label: 'Responsibility Center',
      paths: ['request.responsibleCenter', 'payload.ResponsibilityCenter', 'payload.Responsibility_Center'],
    },
    {
      label: 'Job Title',
      paths: ['payload.JobTitle', 'payload.Job_Title', 'payload.JobTitleDescription'],
    },
    {
      label: 'Job Grade',
      paths: ['payload.JobGrade', 'payload.Job_Grade', 'payload.Grade'],
    },
    {
      label: 'Place of Duty',
      paths: ['payload.PlaceofDuty', 'payload.PlaceOfDuty', 'payload.DutyArea'],
    },
    {
      label: 'Total Net Amount',
      paths: ['payload.TotalNetAmount', 'payload.Total_Net_Amount', 'request.amount'],
      format: 'currency',
    },
    {
      label: 'Rejection Reason',
      paths: [
        'payload.RejectionReason',
        'payload.rejectionReason',
        'payload.Comment',
        'payload.Comments',
      ],
    },
  ],
}
