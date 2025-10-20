interface LogoProps {
  variant?: 'primary' | 'white' | 'black' | 'icon' | 'horizontal' | 'division'
  size?: 'sm' | 'md' | 'lg' | 'xl'
  className?: string
}

export function Logo({ 
  variant = 'primary', 
  size = 'md', 
  className = '' 
}: LogoProps) {
  const sizeClasses = {
    sm: 'h-8',
    md: 'h-12',
    lg: 'h-16',
    xl: 'h-24'
  }
  
  const logoSrc = {
    primary: '/alkeme-logo.svg',
    white: '/alkeme-logo-white.svg',
    black: '/alkeme-logo-black.svg',
    icon: '/alkeme-logo-icon.png',
    horizontal: '/alkeme-logo-horizontal.svg',
    division: '/intelligent-solutions-logo.png'
  }
  
  return (
    <img 
      src={logoSrc[variant]}
      alt="ALKEME Insurance"
      className={`${sizeClasses[size]} w-auto ${className}`}
      loading="lazy"
    />
  )
}

