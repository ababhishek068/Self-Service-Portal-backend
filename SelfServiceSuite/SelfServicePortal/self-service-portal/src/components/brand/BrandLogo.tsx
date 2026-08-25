import { brand } from '@/config/brand'
import { cn } from '@/lib/utils'

type BrandLogoVariant = 'login' | 'auth' | 'topbar' | 'sidebar' | 'mobile'

const variantClass: Record<BrandLogoVariant, string> = {
  login: 'portal-login-logo h-auto w-[min(72%,9.75rem)] sm:w-[10.5rem]',
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
  return (
    <img
      src={brand.logoSrc}
      alt={brand.logoAlt}
      className={cn('select-none object-contain', variantClass[variant], className)}
      draggable={false}
    />
  )
}
