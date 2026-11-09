import { brand } from '@/config/brand'
import { cn } from '@/lib/utils'

type BrandLogoVariant = 'login' | 'auth' | 'topbar' | 'sidebar' | 'mobile'

const variantClass: Record<BrandLogoVariant, string> = {
  login: 'portal-login-logo h-auto w-[min(78%,12.5rem)] sm:w-[13.5rem]',
  auth: 'portal-login-logo h-auto w-[min(70%,8.5rem)]',
  topbar: 'h-8 w-auto max-w-[6.5rem] sm:h-9 sm:max-w-[7.5rem]',
  sidebar: 'mx-auto h-12 w-auto max-h-12 max-w-[6.75rem]',
  mobile: 'h-10 w-auto max-w-[6.5rem]',
}

export function BrandLogo({
  variant,
  className,
}: {
  variant: BrandLogoVariant
  className?: string
}) {
  // Dark teal/navy chrome (login brand pane, sidebar, mobile drawer) needs the
  // white-lettering mark; light surfaces keep the indigo-lettering mark.
  const onDark = variant === 'login' || variant === 'mobile' || variant === 'sidebar'
  return (
    <img
      src={onDark ? brand.logoOnDarkSrc : brand.logoSrc}
      alt={brand.logoAlt}
      className={cn('select-none object-contain', variantClass[variant], className)}
      draggable={false}
    />
  )
}
